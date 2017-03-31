#!/usr/bin/env groovy

def defs = [
   'source'      : './unsorted',
   'destination' : './images',
   'pattern'     : 'yyyy/MM/yyyyMMdd-HHmmss'
]

@Grapes ([
   @Grab(group='com.drewnoakes', module='metadata-extractor', version='2.4.0-beta-1'),
   @Grab(group='commons-io', module='commons-io', version='2.0.1')
])

import com.drew.imaging.ImageMetadataReader
import com.drew.metadata.exif.ExifDirectory
import groovy.io.FileType
import org.apache.commons.io.FileUtils

def shorten = { r,f -> 
   f.canonicalPath.substring(r.canonicalPath.size() + 1) 
}

def stitch = { r, n, u -> 
   new File("${r.canonicalPath}/${n}-${u}.jpg") 
}
   
def probe = { r, n -> 
   def u = new Character('A' as char)
   def f = stitch(r, n, u)
   while (f.exists()) {
      if (u == 'Z') throw new RuntimeException('UID sequence exhausted')
      u = u.next()
      f = stitch(r, n, u)
   }
   return f
}

def taken = { f ->
   def exif = ImageMetadataReader.readMetadata(f).getDirectory(ExifDirectory)
   if (exif && exif.containsTag(ExifDirectory.TAG_DATETIME_ORIGINAL)) {
       return exif.getDate(ExifDirectory.TAG_DATETIME_ORIGINAL)
   } else {
      return null   	   
   }
}

def cli = new CliBuilder(usage:'catalog [options]')
cli.with {
   h longOpt:'help', 'print this message'
   s longOpt:'source', args:1, argName:'dir', 'source directory'
   d longOpt:'destination', args:1, argName:'dir', 'destination root directory'
   r longOpt:'recurse', 'crawl source recursively'
   k longOpt:'keep', 'keep original images in source'
   a longOpt:'auto', 'automatic run with no user prompts' 
   m longOpt:'modified', 'use file last modified date if no EXIF'
   v longOpt:'verbose', 'enable verbose output'
}

def opts = cli.parse(args)
if (!opts || opts.h) {
   cli.usage()
   System.exit(0)
}

def src = new File(opts.s ?: defs.source)
def dst = new File(opts.d ?: defs.destination)

println "Source: [${opts.r ? "recursive" : "flat"} ${opts.k ? "keep" : "delete"}] $src.canonicalPath"
println "Destination: $dst.canonicalPath"
println "Name pattern: $defs.pattern"
println "Date resolution: ${opts.m ? "EXIF or last modified" : "EXIF only"}"

if (!opts.a) {
   System.in.withReader {
      println "Re-run with -h or -help option for configuration details"    
      print "Continue? [y/n]: "      
      if (!"y".equalsIgnoreCase(it.readLine())) {
         System.exit(0)
      }
   }    
}

src.traverse(
   type: FileType.FILES,
   nameFilter: ~/(?i).*\.jpe?g/, 
   maxDepth: opts.r ? -1 : 0
) { 
   try {
      def stamp = taken(it)   	   
      if (!stamp && opts.m) {
         stamp = new Date(it.lastModified())      	      
      }
      if (stamp) {
         def fpath = probe(dst, stamp.format(defs.pattern))
         FileUtils.copyFile(it, fpath, true)
         if (opts.v) {
            println "${shorten(src, it)} --> ${shorten(dst, fpath)}"
         }
         if (!opts.k && !it.delete()) {
            println "WARN: ${shorten(src, it)} ~ Unable to delete"
         }
      } else {
         println "SKIPPED: ${shorten(src, it)} ~ No original date found"
      }
   } catch (Throwable t) {
      println "FAIL: ${shorten(src, it)} ~ ${t.message}"
   }
}
