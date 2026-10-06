// Builds the Steam Windows icon: the Steam circle (top left) with the Sikarugir icon (bottom right).
// Needs Steam for Mac in /Applications. The Sikarugir icon is Configure.icns inside any wrapper, converted to PNG:
//   sips -s format png "<wrapper>.app/Contents/Resources/Configure.icns" --out sikarugir.png
//   swift make-icon.swift sikarugir.png icon.png

import AppKit
func render(_ img: NSImage, _ n: Int) -> NSBitmapImageRep {
  let r = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: n, pixelsHigh: n, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
  NSGraphicsContext.saveGraphicsState(); NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: r)
  NSGraphicsContext.current!.imageInterpolation = .high
  img.draw(in: NSRect(x: 0, y: 0, width: n, height: n)); NSGraphicsContext.restoreGraphicsState(); return r
}
let steamRep = render(NSImage(contentsOfFile: "/Applications/Steam.app/Contents/Resources/Steam.icns")!, 1024)
let steam = NSImage(size: NSSize(width: 1024, height: 1024)); steam.addRepresentation(steamRep)
let src = NSRect(x: 48, y: 1024 - 976 - 1, width: 931, height: 932)
let badge = NSImage(contentsOfFile: CommandLine.arguments[1])!
let S: CGFloat = 1024
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(S), pixelsHigh: Int(S), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState(); NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
NSGraphicsContext.current!.imageInterpolation = .high
// Steam dotyka lewego i górnego brzegu
let s = S * 0.84
steam.draw(in: NSRect(x: 0, y: S - s, width: s, height: s), from: src, operation: .sourceOver, fraction: 1)
// ikona Sikarugira dotyka prawego i dolnego brzegu
let d = S * 0.60
let sh = NSShadow(); sh.shadowBlurRadius = 24; sh.shadowOffset = NSSize(width: 0, height: -8); sh.shadowColor = NSColor.black.withAlphaComponent(0.45)
NSGraphicsContext.saveGraphicsState(); sh.set()
badge.draw(in: NSRect(x: S - d, y: 0, width: d, height: d))
NSGraphicsContext.restoreGraphicsState()
NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: CommandLine.arguments[2]))
