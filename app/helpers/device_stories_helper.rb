# frozen_string_literal: true

module DeviceStoriesHelper
  def grafana_panel(name)
    panels = {
      cpm: { id: 14, dashboard: '/d/DFSxrOLWk/safecast-device-details' },
      map: { id: 8, dashboard: '/d/DFSxrOLWk/safecast-device-details' },
      air_quality: { id: 15, dashboard: '/d/7wsttvxGk/safecast-airnote' },
      air_quality_map: { id: 21, dashboard: '/d/7wsttvxGk/safecast-airnote' }
    }
    panels[name]
  end

  def grafana_url(variant, panel)
    url = (ENV['DEVICE_STORIES_GRAFANA_BASE_URL'] || 'https://grafana.safecast.cc') + panel[:dashboard]
    uri = URI.parse(url)
    if variant == :solo
      parts = uri.path.split('/')
      parts[1] = 'd-solo'
      uri.path = parts.join('/')
    end
    uri
  end

  def grafana_more_data(device_urn)
    includes_note = device_urn.include? 'note:dev'
    url = grafana_url(nil, grafana_panel(includes_note ? :air_quality : :cpm))
    args = {
      from: 'now-90d',
      to: 'now',
      refresh: '15',
      'var-device_urn': device_urn
    }
    url.query = args.to_query
    url.to_s.html_safe
  end

  def grafana_iframe(device_urn, panel_name)
    url = grafana_url(:solo, grafana_panel(panel_name))
    args = {
      from: 'now-90d',
      to: 'now',
      refresh: '15',
      'var-device_urn': device_urn,
      panelId: grafana_panel(panel_name)[:id]
    }
    url.query = args.to_query
    url.to_s.html_safe
  end

  def last_battery_value(last_values)
    last_values[0..last_values.index('v') - 1] unless last_values.index('v').nil?
  end

  def last_cpm_values(last_values)
    index_v = last_values.index('v')
    index_c = last_values.index('c')
    if index_v.nil? && !index_c.nil?
      last_values[0..index_c - 1]
    elsif !index_c.nil?
      last_values[index_v + 1..index_c - 1]
    end
  end

  def last_air_quality_values(last_values)
    index_v = last_values.index('v')
    index_c = last_values.index('c')
    index_u = last_values.index('u')
    if index_c && index_u
      last_values[index_c + 3..index_u - 1]
    elsif index_v && index_u
      last_values[index_v + 1..index_u - 1]
    elsif index_u
      last_values[0..index_u - 1]
    end
  end

  def query_elasticsearch(sensor)
    IngestMeasurement.search "query":
                                 {
                                     "bool": {
                                         "must": [
                                             {
                                                 "range": {
                                                     "service_uploaded": {
                                                         "gte": "now-4w",
                                                         "lte": "now"
                                                     }
                                                 }
                                             },
                                             {
                                                 "match": {
                                                     "device_urn": @device_story.device_urn
                                                 }
                                             }
                                         ]
                                     }
                                 },
                             "size": 0,
                             "aggs":
                                 {
                                     "my_buckets":
                                         {
                                             "composite":
                                                 {
                                                     "size": 1000,
                                                     "sources":
                                                         [
                                                             {
                                                                 "date":
                                                                     {
                                                                         "date_histogram":
                                                                             {
                                                                                 "field": "when_captured",
                                                                                 "interval":  "hour"
                                                                             }
                                                                     }

                                                             }
                                                         ]
                                                 },
                                             "aggregations":
                                                 {
                                                     "sensor":
                                                         {
                                                             "avg":
                                                                 {
                                                                     "field": sensor
                                                                 }
                                                         }
                                                 }
                                         }
                                 }
  end

  def query_elasticsearch_after(sensor, after)
    IngestMeasurement.search "query":
                                 {
                                     "bool": {
                                         "must": [
                                             {
                                                 "range": {
                                                     "service_uploaded": {
                                                         "gte": "now-4w",
                                                         "lte": "now"
                                                     }
                                                 }
                                             },
                                             {
                                                 "match": {
                                                     "device_urn": @device_story.device_urn
                                                 }
                                             }
                                         ]
                                     }
                                 },
                             "aggs":
                                 {
                                     "my_buckets":
                                         {
                                             "composite":
                                                 {
                                                     "size": 10000,
                                                     "sources":
                                                         [
                                                             {
                                                                 "date":
                                                                     {
                                                                         "date_histogram":
                                                                             {
                                                                                 "field": "when_captured",
                                                                                 "interval":  "hour",
                                                                                 "format": "H"
                                                                             }
                                                                     }

                                                             }
                                                         ],
                                                     "after": { "date": after["date"] }
                                                 },
                                             "aggregations":
                                                 {
                                                     "sensor":
                                                         {
                                                             "avg":
                                                                 {
                                                                     "field": sensor
                                                                 }
                                                         }
                                                 }
                                         }
                                 }
  end

  def get_elasticsearch_hash(sensor, max_composites, after = nil)
    q = after ? query_elasticsearch_after(sensor, after) : query_elasticsearch(sensor)
    hash_sensor = {}
    return hash_sensor if q.response["aggregations"]["my_buckets"]["buckets"].size < 1
    after_key = q.response["aggregations"]["my_buckets"]["after_key"]
    q.response["aggregations"]["my_buckets"]["buckets"][0]["sensor"]["value"]
    q.response["aggregations"]["my_buckets"]["buckets"].each do |aggr|
      aggr["key"]["date"]
      date = Time.at(aggr["key"]["date"] / 1000.0).strftime('%Y/%m/%d %H')
      #doc_count = aggr["doc_max_composites"]
      avg_sensor_value = aggr["sensor"]["value"]
      hash_sensor.merge!(date => avg_sensor_value)
    end
    if after_key == nil || max_composites <= 0
      return hash_sensor
    else
      puts "DATE: " + after_key["date"].to_s + max_composites.to_s
      return get_elasticsearch_hash(sensor, max_composites - 1, after_key).merge!(hash_sensor)
    end
  end

  def query_all_sensors
    [{"name": "lnd_7318u", "data":  get_elasticsearch_hash("lnd_7318u", 20) },
     {"name": "lnd_712u", "data":  get_elasticsearch_hash("lnd_712u", 20) },
     {"name": "lnd_7128ec", "data":  get_elasticsearch_hash("lnd_7128ec", 20) },
     {"name": "lnd_7318c", "data":  get_elasticsearch_hash("lnd_7318c", 20) },
     {"name": "lnd_78017w", "data":  get_elasticsearch_hash("lnd_78017w", 20) }]
  end
end
