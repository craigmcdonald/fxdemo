import React from 'react'
import PropTypes from 'prop-types'
import DatePicker from 'react-datepicker/lib/datepicker'
import moment from 'moment'
import style from './CalPicker.scss'
import 'react-datepicker/dist/react-datepicker-cssmodules.css'
const { func, object } = PropTypes

const CalPicker = React.createClass({
  propTypes: {
    minDate: object,
    maxDate: object,
    selected: object,
    onSelect: func
  },
  render() {
    return (
      <div styleName='style.cal-picker'>
        <DatePicker
          minDate={moment().subtract(90,'days')}
          maxDate={moment()}
          selected={this.getValue()}
          onSelect={(val => this.setValue(val))}
        />
      </div>
    )
  },
  getValue() {
    return this.props.selected
  },
  setValue(val) {
    this.props.onSelect(val)
  }
})

export default CalPicker
