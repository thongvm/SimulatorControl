import Foundation
import PlatformLookup

func exe(_ args: [String]) throws {
  var arguments = args
  var version: String?
  var name: String?
  var showAll: Bool = false
  while arguments.isEmpty == false {
    let arg = arguments.removeFirst()
    switch arg {
    case "--version":
      fputs(Version, stdout)
      exit(EXIT_SUCCESS)
    case "--help":
      fputs(Usage, stdout)
      exit(EXIT_SUCCESS)
    case "-v": version = arguments.removeFirst()
    case "-s": showAll = true
    default: name = arg
    }
  }
  guard let localName = name else { throw (Overview) }
  let platforms = try PlatformLookup.findAllDeviceNamed(localName, version: version)
  let platform = platforms.last!
  let deviceFamily = try PlatformLookup.deviceFamilyFrom(localName)
  let output = try PlatformLookup.format(platform, deviceFamily: deviceFamily)
  fputs(output + "\n", stdout)
  if showAll { fputs(platform.description, stdout) }
}

do { try exe(Array(CommandLine.arguments.dropFirst())) }
catch let error as PlatformLookup.PlatformLookupError {
  fputs(error.localizedDescription, stderr)
  exit(EXIT_FAILURE)
}
catch {
  fputs(Usage, stderr)
  exit(EXIT_FAILURE)
}
exit(EXIT_SUCCESS)
