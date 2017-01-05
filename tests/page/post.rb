# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/page/post'

describe 'Page::Post' do
  let(:contents) { '---
title: A Title
slug: a-slug
published: true
---
# Hello World' }
  let(:filenames) { [
    new_tempfile(contents, '2016-01-01-foo'),
    new_tempfile('irrelevant', '2012-01-01-bar')
  ] }
  let(:page) { Page::Post.new(directory: Dir.tmpdir, slug: 'foo') }

  it 'has a title' do
    Dir.stub :glob, filenames do
      page.title.must_equal('A Title')
    end
  end

  it 'formats the post date' do
    Dir.stub :glob, filenames do
      page.date.must_equal('January 1, 2016')
    end
  end

  it 'has the post contents' do
    Dir.stub :glob, filenames do
      page.body.must_include('<h1>Hello World</h1>')
    end
  end
end
