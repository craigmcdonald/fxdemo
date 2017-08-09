import React from 'react'
import PropTypes from 'prop-types'
const { object } = PropTypes

const Results = React.createClass({
  propTypes: {
    data: object
  },
  render () {
    let date = new Date(this.props.data.date)
    let base = this.props.data.base
    let counter = this.props.data.counter
    return (
      <div>
        <h3>FX Result:</h3>
        <p> {base.iso_4217} {base.amount} is worth {counter.iso_4217} {counter.amount} on {date.toDateString()}.</p>
      </div>
    )
  }
})

export default Results
