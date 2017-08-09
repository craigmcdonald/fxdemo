import React from 'react'
import PropTypes from 'prop-types'
const { object } = PropTypes

const Errors = React.createClass({
  propTypes: {
    data: object
  },
  render () {
    let msg = this.props.data.error
    return (
      <div>
        <h3>Oops! Something has gone wrong:</h3>
        <p> {msg} </p>
      </div>
    )
  }
})

export default Errors
