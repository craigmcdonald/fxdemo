import React from 'react'
import { Form, Text } from 'react-form'
import moment from 'moment'
import axios from 'axios'
import SelectBox from '../SelectBox'
import DateSelect from '../DateSelect'
import style from './Search.scss'
import PropTypes from 'prop-types'
const { array, func, object } = PropTypes

const Search = React.createClass({
  propTypes: {
    currentDate: func,
    list: array,
    results: func,
    errors: func
  },
  render () {
    const list = this.props.list
    let currentDate = this.props.currentDate()
    return (
      <div className='fx-form-outer'>
        <Form
          defaultValues={{
            base: 'GBP',
            counter: 'USD',
            date: currentDate
          }}

          onSubmit={(values) => {
            axios.get(`/exchange?date=${values.date.format('YYYY[-]MM[-]DD')}&base=${values.base}&counter=${values.counter}&amount=${values.amount}`)
            .then((response) => {
              this.props.results(response)
            })
            .catch((error) => {
              if (error.response) {
                this.props.errors(error.response)
              }
            })
          }}
        >
          {({submitForm}) => {
            return (
              <form onSubmit={submitForm}>
                <DateSelect name='date' currentDate={currentDate} />
                <SelectBox value='GBP' name='base' list={list} />
                <SelectBox value='USD' name='counter' list={list} />
                <Text
                  styleName = 'style.fx-amount'
                  field='amount'
                  placeholder='Enter amount...'
                />
                <div styleName="style.fx-submit-outer">
                  <button
                    styleName='style.fx-submit'
                    type='submit'>Convert</button>
                </div>
              </form>
            )
          }}
        </Form>
      </div>
    )
  }
})

export default Search
