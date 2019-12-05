// Jsonnet IPv4 adresses converter
//
// Author: kvaps <kvapss@gmail.com>
// License: Apache License, Version 2.0
//
// Examples:
// local ipv4 = import 'ipv4.libsonnet';
// ipv4.fromDec(16909060) yields '1.2.3.4'
// ipv4.fromHex('0B16212C') yields '1.2.3.4'
// ipv4.toDec('1.2.3.4') yields 16909060
// ipv4.toHex('11.22.33.44') yields '0B16212C'
// ipv4.increment(1.2.3.4, 3) yields '1.2.3.7'
// ipv4.range(1.2.3.4, 3) yields ['1.2.3.4', '1.2.3.5', '1.2.3.6', '1.2.3.7']

{
  fromDec(ipDec):: (
    local ipHex = std.format('%.8X', ipDec);
    $.fromHex(ipHex)
  ),
  fromHex(ipHex):: (
    local ipHexChars = std.stringChars(ipHex);
    local octetsHex = [std.join('', ipHexChars[x:x + 2]) for x in [0, 2, 4, 6]];
    local octetsInt = [std.parseHex(x) for x in octetsHex];
    std.format('%d.%d.%d.%d', octetsInt)
  ),
  increment(ip, term=1):: (
    $.fromDec($.toDec(ip) + term)
  ),
  range(ip, term):: (
    local ipDec = $.toDec(ip);
    [
      $.fromDec(x)
      for x in std.range(ipDec, ipDec + term)
    ]
  ),
  toDec(ip):: (
    local ipHex = $.toHex(ip);
    std.parseHex(ipHex)
  ),
  toHex(ip):: (
    local octets = std.split(ip, '.');
    local octetsInt = [std.parseInt(x) for x in octets];
    std.format('%.2X%.2X%.2X%.2X', octetsInt)
  ),
}
