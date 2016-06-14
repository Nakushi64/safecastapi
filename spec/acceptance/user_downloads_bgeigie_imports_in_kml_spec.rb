feature 'Downloading bGeigie imports in KML format', type: :feature do
  let(:bgeigie_import) do
    Fabricate(:bgeigie_import, status: 'done')
  end

  scenario 'downloading KML formatted file' do
    visit(bgeigie_import_path(bgeigie_import, locale: 'en-US'))

    click_link 'Download in KML'

    doc = Nokogiri.XML(page.body)

    expect(doc).to be_xml
    expect(doc.xpath('/xmlns:kml/xmlns:Document/xmlns:Style'))
      .to be_present
  end
end
