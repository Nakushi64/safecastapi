require 'spec_helper'

feature "/api/groups API endpoint" do

  before do
    @user = Fabricate(:user, :email => 'paul@rslw.com', :name => 'Paul Campbell')
  end
  let(:user) { @user.reload }
  
  scenario "create a measurement group" do
    post('/api/groups.json',{
      :auth_token     => user.authentication_token,
      :description    => "This group contains test measurements",
      :device_mfg     => "Safecast",
      :device_model   => "bGeigie",
      :device_sensor  => "LND-7317"
    })
    result = ActiveSupport::JSON.decode(response.body)
    result['description'].should == 'This group contains test measurements'
    result['device_mfg'].should == 'Safecast'
    result['device_model'].should == 'bGeigie'
    result['device_sensor'].should == 'LND-7317'
    result['user_id'].should == user.id
    
    idCreated = result.include?('group_id')
    idCreated.should == true
  end
  
  scenario "empty post" do
    post('/api/groups.json',{ :auth_token => user.authentication_token })
    
    result = ActiveSupport::JSON.decode(response.body)
    result['description'].should == ["can't be blank"]
    #mfg, model, and sensor are optional, but description is required
  end
  
end

feature "/api/groups with existing groups and measurements" do

  let(:user) { Fabricate(:user) }
  let!(:a_group) { Fabricate(:group, {
    :description => "A test group",
    :user => user
  }) }
  let!(:b_group) { Fabricate(:group, :description => "Another test group")}
  let!(:a_measurement) { Fabricate(:measurement, :value => 66, :user => user) }
  
  scenario "all groups (/api/groups)" do
    result = api_get("/api/groups.json")
    result.length.should == 2
    result.map { |obj| obj['description'] }.should == ['A test group', 'Another test group']
  end
  
  scenario "get my groups (/api/users/X/groups)" do
    result = api_get("/api/users/#{user.id}/groups.json")
    result.length.should == 1
    result.first['description'].should == 'A test group'
  end
  
  scenario "create new measurement as a part of a group" do
    result = api_get("/api/users/#{user.id}/groups.json")
    gid = result.first['group_id']
    
    post("/api/groups/#{gid}/measurements.json", {
      :auth_token     => user.authentication_token,
      :measurement    => {
        :value          => 334,
        :unit           => 'cpm',
        :latitude       => 3.3,
        :longitude      => 4.4
      }
    })
    meas = ActiveSupport::JSON.decode(response.body)
    meas['value'].should == 334
    meas['user_id'].should == user.id
    
    grp = api_get("/api/users/#{user.id}/groups.json")
    presence = grp.include?(meas)   #might need to be tweaked to be proper
    presence.should == true
  end
  
  scenario "add an existing measurement to a group" do
    result = api_get("/api/users/#{user.id}/groups.json")
    gid = result.first['group_id']
    
    result = api_get("/api/measurements.json")
    meas = result.first
    
    post("/api/groups/#{gid}/measurements.json", {
      :auth_token     => user.authentication_token,
      :measurement_id => meas.id
    })
    result = ActiveSupport::JSON.decode(response.body)
    result['value'].should == meas.value
    
    grp = api_get("/api/users/#{user.id}/groups.json")
    presence = grp.include?(meas)   #might need to be tweaked to be proper
    presence.should == true
    
  end
  
end