import React from 'react'
import Search from '../Search'
import Results from './Results'
import Errors from './Errors'
import moment from 'moment'
import PropTypes from 'prop-types'
const { array } = PropTypes

const ClientApp = React.createClass({
  propTypes: {
    list: array
  },
  getInitialState () {
    return {
      fxData: {},
      error: {}
    }
  },
  getCurrentDate() {
    return moment()
  },
  updateResults(results) {
    this.setState({error: {}})
    this.setState({fxData: results.data})
  },
  updateErrors(error) {
    this.setState({fxData: {}})
    this.setState({error: error})
  },
  render () {
    let fxResult = <h3>Waiting...</h3>
    if (this.state.fxData.counter) {
      fxResult = <Results data={this.state.fxData} />
    } else if (this.state.error.status) {
      fxResult = <Errors data={this.state.error.data} />
    }
    return (
      <div className='row top-xs'>
        <div className='col-xs-12 col-md-4'>
          <Search
            list={this.props.list}
            results={this.updateResults}
            errors={this.updateErrors}
            currentDate={this.getCurrentDate}
            />
        </div>
        <div className='col-xs-12 col-md-8'>
          {fxResult}
        </div>
      </div>
    )
  }
})

export default ClientApp
