require 'open3'

module Net
  module Fping
    class << self

      def default_options
        {
          retries: 3,
          count: 1,
          bytes: 56,
          interval: 25,
          timeout: 500
        }
      end

      def build_args(opts)
        opts = default_options.merge(opts)
        "-c #{opts[:count]} -r #{opts[:retries]} -t #{opts[:timeout]} -i #{opts[:interval]} -b #{opts[:bytes]}"
      end

      def alive(hosts=[], **opts)
        return [] if hosts.empty?
        args = build_args(opts)
        %x[fping #{args} -a #{hosts.join(" ")} 2>/dev/null].split("\n");
      end

      def dead(hosts=[], **opts)
        return [] if hosts.empty?
        args = build_args(opts)
        %x[fping #{args} -u #{hosts.join(" ")} 2>/dev/null].split("\n")
      end

      def alive_in_subnet(subnet, **opts)
        args = build_args(opts)
        %x[fping #{args} -ag #{subnet} 2>/dev/null].split("\n")
      end

      def alive_in_range(from, to, **opts)
        args = build_args(opts)
        %x[fping #{args} -ag #{from} #{to} 2>/dev/null].split("\n")
      end

      # Added defs for latency based metrics
      def latency_simple(host)
        bytes = 68
        count = 6
        interval = 1000
        %x[fping -b #{bytes} -c #{count} -q -p #{interval} #{host}]
      end

      def latency(host, bytes, count, interval=1000)
        cmd = "fping -b #{bytes} -c #{count} -q -p #{interval} #{host}"
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          # output is written to stderr for some reason
          ltc = stderr.read.gsub(/[%, ]/, "/")
          ltc = ltc.split(/.*loss\/=\/[0-9]+\/[0-9]+\/([0-9]+)\/\/\/min\/avg\/max\/=\/([0-9.]+)\/([0-9.]+)\/([0-9.]+)/)[-5..4]
	        return ltc
        end
      end

    end
  end
end
