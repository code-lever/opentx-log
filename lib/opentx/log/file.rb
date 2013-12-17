require 'csv'
require 'open-uri'

module OpenTx
  module Log

    class File

      # @return [Array<Session>] Sessions contained in this file
      attr_reader :sessions

      # Determines if the file at the given URI is an OpenTx log file.
      #
      # @param uri URI to file to read
      # @return [OpenTx::Log::File] loaded file if the file is an OpenTx log file, nil otherwise
      def self.opentx? uri
        File.new(uri) rescue nil
      end

      def initialize uri
        @sessions = []

        open(uri, 'r') do |file|
          session = CSV.new(file, { headers: true }).map { |csv| csv }

          # a little sanity checking
          raise 'No session data found' if session.empty?
          raise 'Unknown column layout' unless Session.known_rows?(session.first.headers)

          @sessions << Session.new(session)
        end
      rescue => e
        raise ArgumentError, "File does not appear to be an OpenTx log (#{e})"
      end

      # Gets the total duration of all sessions contained within.
      #
      # @return [Float] total duration of all sessions, in seconds
      def duration
        @sessions.map(&:duration).reduce(&:+)
      end

    end

  end
end
