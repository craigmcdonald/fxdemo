import React from 'react'
import { FormInput } from 'react-form'
import CalPicker from './CalPicker'
import PropTypes from 'prop-types'
import moment from 'moment'
const { string, object } = PropTypes

const DateSelect = React.createClass({
  propTypes: {
    name: string,
    currentDate: object
  },
  render () {
    var name = this.props.name
    return (
      <div className='fx-form-datepicker-outer'>
        <FormInput field={name}>
          {({getValue, setValue}) => {
            return (
              <div className='fx-form-datepicker-inner'>
                <CalPicker
                  minDate={moment().subtract(90,'days')}
                  maxDate={moment()}
                  selected={getValue()}
                  onSelect={setValue}
                />
              </div>
            )
          }}
        </FormInput>
      </div>
    )
  }
})

export default DateSelect
