import React from 'react'
import ReactDOM from 'react-dom'
import CalPicker from './CalPicker'
import moment from 'moment'
import { mount, shallow } from 'enzyme'
import { shallowToJson } from 'enzyme-to-json'


test('CalPicker Snapshot Test', () => {
  let dateVal = new Date("2017-08-09T12:53:14.878Z")
  let minDate = new Date("2017-05-11T12:53:14.876Z")
  function changeDate(val) {
    dateVal = val
  }
  const component = shallow(
    <CalPicker
      selected={dateVal}
      onSelect={changeDate}
      minDate={minDate}
      maxDate={dateVal}
    />
  )
  const tree = shallowToJson(component)
  expect(tree).toMatchSnapshot()
})

test('CalPicker has an initial date', () => {
  let dateVal = moment()
  let minDate = moment().subtract(90,'days')
  function changeDate(val) {
    dateVal = val
  }
  const dateselect = mount(
    <CalPicker
      selected={dateVal}
      onSelect={changeDate}
      minDate={minDate}
      maxDate={dateVal}
    />
  )
  expect(dateselect.html()).toMatch(moment().format('MM[/]DD[/]YYYY'))
})
