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

    end

  end
end
