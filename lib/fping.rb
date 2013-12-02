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
        %[fping -ag #{subnet} 2>/dev/null].split("\n")
      end

      def alive_in_range(from, to)
        %[fping -ag #{from} #{to} 2>/dev/null].split("\n")
      end

    end
  end
end
