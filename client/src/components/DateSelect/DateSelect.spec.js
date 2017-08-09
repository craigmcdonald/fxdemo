import React from 'react'
import ReactDOM from 'react-dom'
import DateSelect from './DateSelect'
import { shallow } from 'enzyme'
import { shallowToJson } from 'enzyme-to-json'


test('DateSelect Snapshot Test', () => {
  const component = shallow(
    <DateSelect
      name={'foo'}
    />
  )
  const tree = shallowToJson(component)
  expect(tree).toMatchSnapshot()
})
