gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative '../lib/mail_parser'

class MailParserTest < Minitest::Test
  def test_german_email
    expected_result = { date: '23.01.17',
                        time_start: '19:00',
                        time_end: '19:30',
                        customer: 'Christine Mika',
                        street: 'Bürglistrasse 26',
                        zip: '8002',
                        total: '53,00' }

    assert_equal expected_result, MailParser.parse('test/fixtures/email_1.eml')
  end

  def test_english_email
    expected_result = { date: '12.02.17',
                        time_start: '19:00',
                        time_end: '19:30',
                        customer: 'Mona Moschko',
                        street: 'Sihlhallenstrasse 11',
                        zip: '8004',
                        total: '59.20' }

    assert_equal expected_result, MailParser.parse('test/fixtures/email_2.eml')
  end

  def test_email_3
    expected_result = { date: '12.02.17',
                        time_start: '20:00',
                        time_end: '20:30',
                        customer: 'SERGIO GARCIA',
                        street: 'DUFOURSTRASSE 81',
                        zip: '8008',
                        total: '49.60' }

    assert_equal expected_result, MailParser.parse('test/fixtures/email_3.eml')
  end

  def test_email_4
    expected_result = { date: '12.02.17',
                        time_start: '19:30',
                        time_end: '20:00',
                        customer: 'Mirco Tieppo',
                        street: 'Edenstrasse 5',
                        zip: '8045',
                        total: '43,40' }

    assert_equal expected_result, MailParser.parse('test/fixtures/email_4.eml')
  end

  def test_email_5
    expected_result = { date: '12.02.17',
                        time_start: '19:30',
                        time_end: '20:00',
                        customer: 'Andreas Bingisser',
                        street: 'Birmensdorferstrasse 391',
                        zip: '8055',
                        total: '111,00' }

    assert_equal expected_result, MailParser.parse('test/fixtures/email_5.eml')
  end

  def test_email_6
    expected_result = { date: '12.02.17',
                        time_start: '19:00',
                        time_end: '19:30',
                        customer: 'David Shilling',
                        street: 'Grubenstrasse 15',
                        zip: '8045',
                        total: '57,60' }

    assert_equal expected_result, MailParser.parse('test/fixtures/email_6.eml')
  end

  def test_email_7
    expected_result = { date: '12.02.17',
                        time_start: '18:30',
                        time_end: '19:00',
                        customer: 'Alexander Schütz',
                        street: 'Wengistrasse 4',
                        zip: '8004',
                        total: '55,10' }

    assert_equal expected_result, MailParser.parse('test/fixtures/email_7.eml')
  end
end
