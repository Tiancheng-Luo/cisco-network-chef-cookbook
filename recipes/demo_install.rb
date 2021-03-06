#
# Cookbook Name:: cisco-cookbook
# Recipe:: demo_install
#
# Copyright (c) 2014-2017 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# In our recipes, due to the number of different parameters, we prefer to align
# the arguments in a single column rather than following rubocop's style.

Chef::Log.info('Demo cisco_command_config provider')

cisco_command_config 'loop42' do
  action :update
  command '
    interface loopback42
      description Peering for AS 42
      ip address 192.168.1.42/24
  '
end

cisco_command_config 'system-switchport-default' do
  command 'no system default switchport'
end

cisco_command_config 'feature_bgp' do
  command ' feature bgp'
end

cisco_command_config 'router_bgp_42' do
  action :update
  command '
    router bgp 42
      router-id 192.168.1.42
      address-family ipv4 unicast
        network 1.0.0.0/8
        redistribute static route-map bgp-statics
      neighbor 10.1.1.1
        remote-as 99
  '
end

cisco_command_config 'route42' do
  action :update
  command ' ip route 10.42.42.42/32 Null0 '
end

# The following tests 'no' commands that do not
# nvgen when enabled.
# We need to first configure the port-channel interface
# so that it exists before applying the 'no' commands.

cisco_command_config 'port-channel55-setup' do
  action :update
  command '
    feature bfd
    interface port-channel55
  '
end

cisco_command_config 'port-channel55' do
  action :update
  command '
    interface port-channel55
      no switchport
      no bfd echo
      no ip redirects
  '
end

Chef::Log.info('Demo cisco_interface provider')

cisco_interface 'Ethernet1/1' do
  shutdown            true
  description         'managed by chef'
  ipv4_address        '192.0.2.43'
  ipv4_netmask_length 24
  mtu                 1600
  vrf                 'vrf_member'
end

cisco_interface 'Ethernet1/1.1' do
  encapsulation_dot1q 10
end

cisco_interface 'Ethernet1/2' do
  # set all props to default
end

cisco_interface 'Ethernet1/3' do
  switchport_mode 'trunk'
  switchport_trunk_allowed_vlan '20, 30'
  switchport_trunk_native_vlan 40
end

cisco_interface 'Vlan22' do
  svi_autostate  false
  svi_management true
end

Chef::Log.info('Demo cisco_vlan provider')

cisco_vlan '220' do
  action    :create
  vlan_name 'newtest'
  shutdown  true
  state     'active'
end

Chef::Log.info('Demo cisco_ospf providers')

cisco_ospf 'Sample' do
  action :create
end

cisco_interface_ospf 'Ethernet1/4' do
  action                         :create
  ospf                           'Sample'
  area                           200
  cost                           200
  hello_interval                 200
  dead_interval                  200
  message_digest                 true
  message_digest_key_id          7
  message_digest_encryption_type 'cisco_type_7'
  message_digest_algorithm_type  'md5'
  message_digest_password        '046E1803362E595C260E0B240619050A2D'
  passive_interface              true
end

cisco_ospf_vrf 'dark_blue default' do
  auto_cost                45000
  default_metric           5
  log_adjacency            'detail'
  timer_throttle_lsa_hold  5500
  timer_throttle_lsa_max   5600
  timer_throttle_lsa_start 5
  timer_throttle_spf_hold  1500
  timer_throttle_spf_max   5500
  timer_throttle_spf_start 250
end

cisco_ospf_vrf 'dark_blue vrf1' do
  auto_cost                46000
  default_metric           10
  log_adjacency            'log'
  timer_throttle_lsa_hold  5600
  timer_throttle_lsa_max   5800
  timer_throttle_lsa_start 8
  timer_throttle_spf_hold  1700
  timer_throttle_spf_max   5700
  timer_throttle_spf_start 277
end

Chef::Log.info('Demo cisco_tacacs providers')

cisco_tacacs_server 'test' do
  action              :create
  timeout             10
  directed_request    true
  deadtime            20
  encryption_type     'clear'
  encryption_password 'test123'
  source_interface    'Ethernet1/2'
end

cisco_tacacs_server_host 'testhost' do
  action              :create
  port                66
  timeout             33
  encryption_type     'clear'
  encryption_password 'foobarpassword'
end

Chef::Log.info('Demo cisco_vtp provider')

cisco_vtp 'default' do
  action      :create
  domain      'cisco1234'
  password    'test1234'
  version     2
  filename    'bootflash:/vlan.dat'
end

Chef::Log.info('Demo cisco_snmp providers')

cisco_snmp_server 'default' do
  contact                'user1'
  location               'rtp'
  packet_size             2500
  aaa_user_cache_timeout  1000
  tcp_session_auth        false
  protocol                false
  global_enforce_priv     true
end

cisco_snmp_group 'network-admin' do
  action :create
end

cisco_snmp_community 'setcom' do
  action    :create
  group     'network-admin'
  acl       'testcomacl'
end

cisco_snmp_user 'v3test' do
  groups ['network-admin']
end
