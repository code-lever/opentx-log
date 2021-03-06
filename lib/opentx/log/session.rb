module OpenTx
  module Log

    class Session

      # XXX currently just know Taranis X9D files...
      def self.known_rows?(headers)
        return false unless [48].include?(headers.length)

        # check for a few known headers
        (%w(Date Time SWR RSSI A1 A2 Long Lat Temp1 Temp2 RPM Fuel) - headers).empty?
      end

      def initialize(csv_rows)
        @rows = csv_rows
      end

      def duration
        milliseconds
        times.last - times.first
      end

      # @return [Array<Float>] millisecond time stamps for all entries, 0-based
      def milliseconds
        @milliseconds ||= times.map { |time| ((time - times.first) * 1000).round(2) }
      end

      # @return [Array<Time>] all date-times in the session
      def times
        @times ||= @rows.map { |row| Time.strptime("#{row['Date']} #{row['Time']}", '%Y-%m-%d %H:%M:%S.%N') }
      end

      def swr?
        swr.any?
      end

      def swr
        @swr ||= int_field('SWR')
      end

      def rssi?
        rssi.any?
      end

      def rssi
        @rssi ||= int_field('RSSI')
      end

      def a1?
        a1.any? { |v| v > 0.0 }
      end

      def a1
        @a1 ||= float_field('A1')
      end

      def a2?
        a2.any? { |v| v > 0.0 }
      end

      def a2
        @a2 ||= float_field('A2')
      end

      def temp1?
        int_field('Temp1').any? { |t| t != 0 }
      end

      def temp1(unit = :c)
        @temp1 ||= int_field('Temp1')
        @temp1.map { |t| convert_temperature(t, unit) }
      end

      def temp2?
        int_field('Temp2').any? { |t| t != 0 }
      end

      def temp2(unit = :c)
        @temp2 ||= int_field('Temp2')
        @temp2.map { |t| convert_temperature(t, unit) }
      end

      def fuel?
        fuel.any? { |f| f != 0 }
      end

      def fuel
        @fuel ||= int_field('Fuel')
      end

      def cell_volts?
        cell_volts.any? { |v| v > 0.0 }
      end

      def cell_volts
        @cell_volts ||= float_field('Cell volts')
      end

      # @param index [1..6]
      def cell?(index)
        cell(index).any? { |v| v > 0.0 }
      end

      # @param index [1..6]
      def cell(index)
        float_field("Cell #{index}")
      end

      private

      def convert_temperature(celsius, unit)
        case unit
        when :f
          (celsius * (9.0 / 5.0)) + 32
        else
          celsius
        end
      end

      def float_field(name)
        @rows.map { |row| row[name].to_f }
      end

      def int_field(name)
        @rows.map { |row| row[name].to_i }
      end

    end

  end
end
