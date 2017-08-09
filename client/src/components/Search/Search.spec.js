import React from 'react'
import ReactDOM from 'react-dom'
import Search from './Search'
import { shallow } from 'enzyme'
import moment from 'moment'
import { shallowToJson } from 'enzyme-to-json'


test('Search Snapshot Test', () => {
  const list = [['AUS','Australian Dollar']]
  const results = function(){}
  const errors = function(){}
  const currentDate = function() {
    return new Date("2017-08-09T12:53:14.878Z")
  }
  const component = shallow(
    <Search
      list={list}
      results={results}
      errors={errors}
      currentDate={currentDate}
    />
  )
  const tree = shallowToJson(component)
  expect(tree).toMatchSnapshot()
})
