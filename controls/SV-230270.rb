control 'SV-230270' do
  title 'RHEL 8 must prevent kernel profiling by unprivileged users.'
  desc  "Preventing unauthorized information transfers mitigates the risk of
information, including encrypted representations of information, produced by
the actions of prior users/roles (or the actions of processes acting on behalf
of prior users/roles) from being available to any current users/roles (or
current processes) that obtain access to shared system resources (e.g.,
registers, main memory, hard disks) after those resources have been released
back to information systems. The control of information in shared resources is
also commonly referred to as object reuse and residual information protection.

    This requirement generally applies to the design of an information
technology product, but it can also apply to the configuration of particular
information system components that are, or use, such products. This can be
verified by acceptance/validation processes in #{input('org_name')[:acronym]} or other government agencies.

    There may be shared resources with configurable protections (e.g., files in
storage) that may be assessed on specific information system components.

    Setting the kernel.perf_event_paranoid kernel parameter to \"2\" prevents
attackers from gaining additional system information as a non-privileged user.
  "
  desc  'rationale', ''
  desc  'check', "
    Verify the operating system is configured to prevent kernel profiling by
unprivileged users with the following commands:

    Check the status of the kernel.perf_event_paranoid kernel parameter.

    $ sudo sysctl kernel.perf_event_paranoid

    kernel.perf_event_paranoid = 2

    If \"kernel.perf_event_paranoid\" is not set to \"2\" or is missing, this
is a finding.

    Check that the configuration files are present to enable this kernel
parameter.

    $ sudo grep -r kernel.perf_event_paranoid /etc/sysctl.conf
/etc/sysctl.d/*.conf

    /etc/sysctl.d/99-sysctl.conf:kernel.perf_event_paranoid = 2

    If \"kernel.perf_event_paranoid\" is not set to \"2\", is missing or
commented out, this is a finding.
  "
  desc 'fix', "
    Configure the operating system to prevent kernel profiling by unprivileged
users.

    Add or edit the following line in a system configuration file in the
\"/etc/sysctl.d/\" directory:

    kernel.perf_event_paranoid = 2

    Load settings from all system configuration files with the following
command:

    $ sudo sysctl --system
  "
  impact 0.3
  tag severity: 'low'
  tag gtitle: 'SRG-OS-000138-GPOS-00069'
  tag gid: 'V-230270'
  tag rid: 'SV-230270r627750_rule'
  tag stig_id: 'RHEL-08-010376'
  tag fix_id: 'F-32914r567557_fix'
  tag cci: ['CCI-001090']
  tag nist: ['SC-4']

  if virtualization.system.eql?('docker')
    impact 0.0
    describe "Control not applicable within a container" do
      skip "Control not applicable within a container"
    end
  else
    describe kernel_parameter('kernel.perf_event_paranoid') do
      its('value') { should eq 2 }
    end
  
    describe parse_config(command('grep -rh ^kernel.perf_event_paranoid /etc/sysctl.conf /etc/sysctl.d/*.conf').stdout.strip) do
      its(['kernel.perf_event_paranoid']) { should cmp 2 }
    end
  end
end
