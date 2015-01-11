require 'open3'

module Net
  module Fping
    class << self

      def alive(hosts=[])
        return [] if hosts.empty?
        %x[fping -a #{hosts.join(" ")} 2>/dev/null].split("\n");
      end

      def dead(hosts=[])
        return [] if hosts.empty?
        %x[fping -u #{hosts.join(" ")} 2>/dev/null].split("\n")
      end

      def alive_in_subnet(subnet)
        %x[fping -ag #{subnet} 2>/dev/null].split("\n")
      end

      def alive_in_range(from, to)
        %x[fping -ag #{from} #{to} 2>/dev/null].split("\n")
      end
      
      # Added defs for latency based metrics
      def latency_simple(host)
        bytes = 68
        count = 6
        interval = 1000
        %x[fping -b #{bytes} -c #{count} -q -p #{interval} #{host}]
      end

      def latency(host, bytes, count, interval)
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
