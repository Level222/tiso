# shellcheck shell=sh disable=SC2016,SC2317

Describe 'tiso'
  original_gdate=${GNU_DATE:-gdate}

  original_gdate_support=$(
    if [ "$original_gdate" = gdate ]; then
      printf '@gdate'
    else
      printf %s "$original_gdate"
    fi
  )

  current_gdate=$original_gdate

  fixed_date='"$current_gdate" -d "2023-12-04 14:29:53.123456789 EST"'

  save_tz() {
    original_tz=$TZ
  }

  restore_tz() {
    export TZ="$original_tz"
  }

  set_tz() {
    export TZ="$1"
  }

  save_and_set_current_gdate() {
    current_gdate=gdate
  }

  restore_current_gdate() {
    current_gdate=$original_gdate
  }

  BeforeAll 'save_tz'
  AfterAll 'restore_tz'

  BeforeEach 'set_tz EST'

  Context 'using the format type options'
    Parameters
      "basic"    "-b" "20231204T142953"
      "extended" "-e" "2023-12-04T14:29:53"
    End

    It "should display date and time in $1 format"
      When run source ./bin/tiso -D "$fixed_date" "$2"
      The output should eq "$3"
    End
  End

  Context 'displaying in dates'
    Context 'using calendar dates'
      Context 'using valid options'
        Parameters
          "years"  "-Y"  "2023"
          "months" "-m"  "2023-12"
          "days"   "-d"  "2023-12-04"
          "years"  "-bY" "2023"
          "days"   "-bd" "20231204"
        End

        It "should display date in $1"
          When run source ./bin/tiso -D "$fixed_date" -C "$2"
          The output should eq "$3"
        End
      End

      Context 'using invalid options'
        Parameters
          "-w"  "The weeks option is only valid with week dates mode."
          "-bm" "In ISO 8601 basic format, only year and month are not allowed."
        End

        It "should raise an error"
          When run source ./bin/tiso -C "$1"
          The status should be failure
          The error should eq "$2"
        End
      End
    End

    Context 'using week dates'
      Context 'using valid options'
        Parameters
          "years" "-Y"  "2023"
          "weeks" "-w"  "2023-W49"
          "days"  "-d"  "2023-W49-1"
          "years" "-bY" "2023"
          "weeks" "-bw" "2023W49"
          "days"  "-bd" "2023W491"
        End

        It "should display date in $1"
          When run source ./bin/tiso -D "$fixed_date" -W "$2"
          The output should eq "$3"
        End
      End

      Context 'using invalid options'
        Parameters
          "-m" "The months option is only valid with calendar dates mode."
        End

        It "should raise an error"
          When run source ./bin/tiso -W "$1"
          The status should be failure
          The error should eq "$2"
        End
      End

      Context 'at the end of 2019'
        It "should display 1st Thursday of 2020"
          When run source ./bin/tiso -D '"$current_gdate" -d 2019-12-31' -Wd
          The output should eq "2020-W01-2"
        End
      End

      Context 'at the start of 2020'
        It "should display 1st Wednesday of 2020"
          When run source ./bin/tiso -D '"$current_gdate" -d 2020-01-01' -Wd
          The output should eq "2020-W01-3"
        End
      End

      Context 'at the end of 2020'
        It "should display 53rd Thursday of 2020"
          When run source ./bin/tiso -D '"$current_gdate" -d 2020-12-31' -Wd
          The output should eq "2020-W53-4"
        End
      End

      Context 'at the start of 2021'
        It "should display 53rd Friday of 2020"
          When run source ./bin/tiso -D '"$current_gdate" -d 2021-01-01' -Wd
          The output should eq "2020-W53-5"
        End
      End
    End

    Context 'using ordinal dates'
      Context 'using valid options'
        Parameters
          "years" "-Y"  "2023"
          "days"  "-d"  "2023-338"
          "years" "-bY" "2023"
          "days"  "-bd" "2023338"
        End

        It "should display date in $1"
          When run source ./bin/tiso -D "$fixed_date" -O "$2"
          The output should eq "$3"
        End
      End

      Context 'using invalid options'
        Parameters
          "-m" "The months option is only valid with calendar dates mode."
          "-w" "The weeks option is only valid with week dates mode."
        End

        It "should raise an error"
          When run source ./bin/tiso -O "$1"
          The status should be failure
          The error should eq "$2"
        End
      End
    End
  End

  Context 'displaying in times'
    Parameters
      "hours"   "-H" "2023-12-04T14"
      "minutes" "-M" "2023-12-04T14:29"
      "seconds" "-S" "2023-12-04T14:29:53"
      "hours"   "-bH" "20231204T14"
      "minutes" "-bM" "20231204T1429"
      "seconds" "-bS" "20231204T142953"
    End

    It "should display date and time in $1"
      When run source ./bin/tiso -D "$fixed_date" "$2"
      The output should eq "$3"
    End
  End

  Context 'displaying with a decimal fraction'
    Context 'displaying in times'
      Parameters
        "hours"   "-H" "2023-12-04T14.498"
        "minutes" "-M" "2023-12-04T14:29.885"
        "seconds" "-S" "2023-12-04T14:29:53.123"
      End

      It "should display date and time with a decimal fraction in $1"
        When run source ./bin/tiso -D "$fixed_date" -p 3 "$2"
        The output should eq "$3"
      End
    End

    Context 'using shortcut for precision option'
      Parameters
        "0" "-0" "2023-12-04T14:29:53"
        "1" "-1" "2023-12-04T14:29:53.1"
        "2" "-2" "2023-12-04T14:29:53.12"
        "3" "-3" "2023-12-04T14:29:53.123"
        "4" "-4" "2023-12-04T14:29:53.1234"
        "5" "-5" "2023-12-04T14:29:53.12345"
        "6" "-6" "2023-12-04T14:29:53.123456"
        "7" "-7" "2023-12-04T14:29:53.1234567"
        "8" "-8" "2023-12-04T14:29:53.12345678"
        "9" "-9" "2023-12-04T14:29:53.123456789"
      End

      It "should display date and time with $1-digit decimal fraction"
        When run source ./bin/tiso -D "$fixed_date" "$2"
        The output should eq "$3"
      End
    End

    Context 'without support for '%N' format in the date command'
      gdate() {
        for arg in "$@"; do
          case $arg in +*%N)
            printf "abcdefghi\n"
            return 0
          esac
        done

        "$original_gdate_support" "$@"
      }

      BeforeEach 'save_and_set_current_gdate'
      AfterEach 'restore_current_gdate'

      It "should display date and time with a decimal fraction of 0"
        When run source ./bin/tiso -D "$fixed_date" -p 3
        The output should eq "2023-12-04T14:29:53.000"
      End
    End

    Context 'using very long precision option'
      It "should display date and time with a decimal fraction without new line"
        When run source ./bin/tiso -D "$fixed_date" -p 70
        The output should eq "2023-12-04T14:29:53.1234567890000000000000000000000000000000000000000000000000000000000000"
      End
    End

    Context 'not using a positive integer to the precision'
      Parameters
        "-1"
        "1.5"
      End

      It "should raise an error"
        When run source ./bin/tiso -p "$1"
        The status should be failure
        The error should eq "Precision for decimal points must be a positive integer."
      End
    End

    Context 'displaying in dates'
      It "should raise an error"
        When run source ./bin/tiso -d -p 1
        The status should be failure
        The error should eq "The precision option cannot be used with the option to display only dates."
      End
    End

    Context 'specifying a decimal separator'
      Parameters
        "dot"   "-f" "2023-12-04T14:29:53.123"
        "comma" "-c" "2023-12-04T14:29:53,123"
      End

      It "should display date and time with a decimal fraction using a $1 as the decimal separator"
        When run source ./bin/tiso -D "$fixed_date" -p 3 "$2"
        The output should eq "$3"
      End
    End
  End

  Context 'displaying time zone'
    Context 'using valid time zone options'
      Parameters
        "without displaying time zone"     "-i" "2023-12-04T14:29:53"
        "and display time zone in minutes" "-z" "2023-12-04T14:29:53-05:00"
        "and display time zone in hours"   "-Z" "2023-12-04T14:29:53-05"
      End

      It "should display date and time $1"
        When run source ./bin/tiso -D "$fixed_date" "$2"
        The output should eq "$3"
      End
    End

    Context 'using basic format'
      Parameters
        "minutes" "-z" "20231204T142953-0500"
        "hours"   "-Z" "20231204T142953-05"
      End

      It "should display date, time and time zone in $1"
        When run source ./bin/tiso -D "$fixed_date" -b "$2"
        The output should eq "$3"
      End
    End

    Context 'without support for '%z' format in the date command'
      gdate() {
        for arg in "$@"; do
          case $arg in +*%z)
            return 0
          esac
        done

        "$original_gdate_support" "$@"
      }

      BeforeEach 'save_and_set_current_gdate'
      AfterEach 'restore_current_gdate'

      It "should display date, time and time zone"
        When run source ./bin/tiso -D "$fixed_date" -z
        The output should eq "2023-12-04T14:29:53-05:00"
      End

      It "should display date, time and time zone when the month is less than 3"
        When run source ./bin/tiso -D '"$current_gdate" -d "2023-02-04 EST"' -z
        The output should eq "2023-02-04T00:00:00-05:00"
      End
    End

    Context 'using hourly time zone option in Asia/Kolkata time'
      BeforeEach 'set_tz Asia/Kolkata'

      It "should raise an error"
        When run source ./bin/tiso -Z
        The status should be failure
        The error should eq "The hourly time zone option must be used in a time zone with 0 minutes."
      End
    End

    Context 'using valid UTC options'
      Parameters
        "local time"                 "-l" "2023-12-04T14:29:53"
        "UTC time"                   "-u" "2023-12-04T19:29:53"
        "UTC time with Z designator" "-U" "2023-12-04T19:29:53Z"
      End

      It "should display date and time in $1"
        When run source ./bin/tiso -D "$fixed_date" "$2"
        The output should eq "$3"
      End
    End

    Context 'using invalid options'
      It "should raise an error"
        When run source ./bin/tiso -zU
        The status should be failure
        The error should eq "UTC with time zone option cannot be used with time zone options."
      End
    End

    Context 'using an alternative minus sign'
      It "should display date and time, and time zone"
        When run source ./bin/tiso -D "$fixed_date" -z -s _
        The output should eq "2023-12-04T14:29:53_05:00"
      End
    End

    Context 'using multiple characters as an alternative minus sign'
      It "should raise an error"
        When run source ./bin/tiso -s ABC
        The status should be failure
        The error should eq "The type of minus sign for the time zone must be a single character."
      End
    End
  End

  Context 'using new line suppression options'
    raw_length() {
      printf %s ${#1}
    }

    Parameters
      "by suppressing new line"      "-n" "19"
      "without suppressing new line" "-N" "20"
    End

    It "should display date and time $1"
      When run source ./bin/tiso -D "$fixed_date" "$2"
      The output should eq 2023-12-04T14:29:53
      The result of function raw_length should eq "$3"
    End
  End

  Context 'using version option'
    It "should show version"
      When run source ./bin/tiso -v
      The output should be present
    End
  End

  Context 'using help option'
    It "should show help"
      When run source ./bin/tiso -h
      The output should be present
    End
  End

  Context 'using non-existent options'
    It "should raise an error"
      When run source ./bin/tiso -#
      The status should be failure
      The error should end with "View help: tiso -h"
    End
  End

  Context 'without availability of the gdate command'
    command() {
      return 1
    }

    date() {
      "$current_gdate" "$@"
    }

    It "should display date and time using the date command"
      When run source ./bin/tiso
      The output should be present
    End
  End
End
