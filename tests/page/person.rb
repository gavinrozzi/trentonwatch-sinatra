# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ep/people_by_legislature'
require_relative '../../lib/membership_csv/people'
require_relative '../../lib/page/person'
require_relative 'person_interface_test'

describe 'Page::Person' do
  let(:people) { EP::PeopleByLegislature.new(
    legislature: nigeria_at_known_revision.legislature('Representatives'),
    mapit: 'irrelevant',
    baseurl: 'irrelevant'
  ) }
  let(:page) { Page::Person.new(
    person: people.find_single('b2a7f72a-9ecf-4263-83f1-cb0f8783053c'),
    position: 'Position',
    summary_doc: FakeSummary.new('<p>foo</p>')
  ) }

  it 'knows the position' do
    page.position.must_equal('Position')
  end

  it 'has a page title' do
    page.title.must_equal('ABDUKADIR RAHIS')
  end

  it 'has a social media share name' do
    page.share_name.must_equal('ABDUKADIR RAHIS')
  end

  it 'has a summary' do
    page.summary.must_equal('<p>foo</p>')
  end

  describe 'when page is an EP person' do
    include PersonInterfaceTest
    let(:person) { page.person }
  end

  describe 'when page is a Morph person' do
    include PersonInterfaceTest
    let(:contents) { 'id
1'
    }
    let(:people) { MembershipCSV::People.new(
      csv_filename: new_tempfile(contents),
      mapit: 'irrelevant',
      baseurl: 'irrelevant'
    ) }
    let(:page) { Page::Person.new(
      person: people.find_single('1'),
      position: 'irrelevant',
      summary_doc: 'irrelevant'
    ) }
    let(:person) { page.person }
  end

  FakeSummary = Struct.new(:body)
end
