# frozen_string_literal: true
require_relative 'everypolitician_extensions'
require_relative 'person'

module EP
  class PeopleByLegislature
    def initialize(legislature:, mapit:, baseurl:)
      @legislature = legislature
      @mapit = mapit
      @baseurl = baseurl
    end

    def find_all
      @find_all ||= people_sorted_by_name.map { |person| create_person(person) }
    end

    def find_single(id)
      find_all.find { |person| person.id == id }
    end

    def none?(id)
      find_single(id).nil?
    end

    private

    attr_reader :legislature, :mapit, :baseurl

    def people_sorted_by_name
      latest_term.people.sort_by { |person| [person.sort_name, person.name] }
    end

    def latest_term
      legislature.legislative_periods.sort_by { |term| term.start_date }.last
    end

    def create_person(person)
      Person.new(person: person, term: latest_term, mapit: mapit, baseurl: baseurl)
    end
  end
end
