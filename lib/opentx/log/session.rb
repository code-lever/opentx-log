module OpenTx
  module Log

    class Session

      # XXX currently just know Taranis X9D files...
      def self.known_rows?(headers)
        return false unless [48].include?(headers.length)

        # check for a few known headers
        (%w(Date Time SWR RSSI A1 A2 Long Lat Temp1 Temp2 RPM Fuel) - headers).empty?
      end

      def initialize(csv)
        @csv = csv
      end

      def duration
        0
      end

    end

  end
end
