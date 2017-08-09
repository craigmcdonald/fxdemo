import React from 'react'
import { FormInput } from 'react-form'
import Select from 'react-select'
import './SelectBox.scss'
import PropTypes from 'prop-types'
const { string, array } = PropTypes

const SelectBox = React.createClass({
  propTypes: {
    name: string,
    list: array
  },
  render () {
    var options = this.props.list
    var name = this.props.name
    return (
      <div className='fx-form-currency-select'>
        <FormInput field={name}>
          {({ getValue, setValue }) => {
            return (
              <Select
                styleName='fx-currency-input'
                name={name}
                options={options}
                simpleValue
                value={getValue()}
                onChange={val => setValue(val)}
              />
            )
          }}
        </FormInput>
      </div>
    )
  }
})

export default SelectBox
