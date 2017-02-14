gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative '../lib/mail_parser'

class MailParserTest < Minitest::Test
  def test_german_email
    expected_result = { date: '23.01.17',
                        time_window: '19:00-19:30',
                        customer: 'Christine Mika',
                        street: 'Bürglistrasse 26',
                        zip: '8002',
                        total: '53,00' }

    assert_equal expected_result, MailParser.parse('test/fixtures/email_1.eml')
  end

  def test_english_email
    expected_result = { date: '12.02.17',
                        time_window: '19:00-19:30',
                        customer: 'Mona Moschko',
                        street: 'Sihlhallenstrasse 11',
                        zip: '8004',
                        total: '59.20' }

    assert_equal expected_result, MailParser.parse('test/fixtures/email_2.eml')
  end

end
