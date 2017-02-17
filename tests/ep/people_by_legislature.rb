# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ep/people_by_legislature'

describe 'EP::PeopleByLegislature' do
  let(:legislature) { nigeria_at_known_revision.legislature('Representatives') }
  describe 'class methods' do
    let(:people) { EP::PeopleByLegislature.new(
      legislature: legislature,
      mapit: 'irrelevant',
      baseurl: '/baseurl/'
    ) }

    it 'has a list of all the people' do
      people.find_all.count.must_equal(362)
    end

    it 'has people from the current term' do
      people.find_all.first.memberships.first.legislative_period.id.must_equal('term/2015')
    end

    it 'sorts people by name' do
      (people.find_all.first.name < people.find_all.last.name).must_equal(true)
    end

    it 'people are person objects' do
      people.find_all.first.id.must_equal('b2a7f72a-9ecf-4263-83f1-cb0f8783053c')
    end

    it 'uses the baseurl in the person url' do
      people.find_all.first.url.must_equal('/baseurl/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/')
    end

    it 'finds a single person by id' do
      people.find_single('b2a7f72a-9ecf-4263-83f1-cb0f8783053c').name
        .must_equal('ABDUKADIR RAHIS')
    end

    it 'can check if id does not exist in this legislature' do
      people.none?('i-do-not-exist').must_equal(true)
    end

    it 'knows the start date of the current term' do
      people.current_term_start_date.year.must_equal(2015)
      people.current_term_start_date.month.must_equal(6)
      people.current_term_start_date.day.must_equal(9)
    end

    it 'knows its legislature name' do
      people.legislature_name.must_equal('House of Representatives')
    end
  end

  describe 'extra mapit functionality' do
    let(:people) { EP::PeopleByLegislature.new(
      legislature: legislature,
      mapit: FakeMapit.new(1),
      baseurl: '/baseurl/'
    ) }

    it 'assigns a mapit area to the person' do
      people.find_single('b2a7f72a-9ecf-4263-83f1-cb0f8783053c').area.id
        .must_equal(1)
    end

    it 'finds all people in a mapit area' do
      people.find_all_by_mapit_area(1).count.must_equal(362)
    end
  end
end
