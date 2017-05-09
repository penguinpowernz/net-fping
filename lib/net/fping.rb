require 'open3'

module Net
  module Fping
    class << self
      # Check to see if fping is actually installed first
      def fping_installed?
        system 'which fping'
        $?.exitstatus == 0
      end

      def default_options
        {
          retries: 3,
          bytes: 56,
          interval: 10,
          timeout: 500
        }
      end

      def build_args(opts)
        opts = default_options.merge(opts)
        "-r #{opts[:retries]} -t #{opts[:timeout]} -i #{opts[:interval]} -b #{opts[:bytes]}"
      end

      def alive(hosts=[], **opts)
        return ['fping not installed!'] unless fping_installed?
        return [] if hosts.empty?

        args = build_args(opts)
        %x[fping #{args} -a #{hosts.join(" ")} 2>/dev/null].split("\n");
      end

      def dead(hosts=[], **opts)
        return ['fping not installed!'] unless fping_installed?
        return [] if hosts.empty?

        args = build_args(opts)
        %x[fping #{args} -u #{hosts.join(" ")} 2>/dev/null].split("\n")
      end

      def alive_in_subnet(subnet, **opts)
        return ['fping not installed!'] unless fping_installed?

        args = build_args(opts)
        %x[fping #{args} -ag #{subnet} 2>/dev/null].split("\n")
      end

      def alive_in_range(from, to, **opts)
        return ['fping not installed!'] unless fping_installed?

        args = build_args(opts)
        %x[fping #{args} -ag #{from} #{to} 2>/dev/null].split("\n")
      end

      # Added defs for latency based metrics
      def latency_simple(host)
        return ['fping not installed!'] unless fping_installed?

        bytes = 68
        count = 6
        interval = 1000
        %x[fping -b #{bytes} -c #{count} -q -p #{interval} #{host}]
      end

      def latency(host, bytes, count, interval=1000)
        return ['fping not installed!'] unless fping_installed?

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
