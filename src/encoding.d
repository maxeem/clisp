# Encodings (character sets and conversions) for CLISP
# Bruno Haible 1998-2002
# Sam Steingold 1998-2002

#include "lispbibl.c"

#include <string.h> # declares memcpy()

#ifdef UNICODE
#include "libcharset.h"
#endif

# =============================================================================
#                             Individual encodings

#ifdef UNICODE

# NOTE 1! The mblen function has to be consistent with the mbstowcs function
# (when called with stream = nullobj).
# The wcslen function has to be consistent with the wcstombs function (when
# called with stream = nullobj).

# NOTE 2! The conversion from bytes to characters (mbstowcs function) is
# subject to the following restriction: At most one byte lookahead is needed.
# This means, when someone calls mbstowcs for converting one character, and
# he tries it with 1 byte, then with one more byte, then with one more byte,
# and so on: when the conversion succeeds for the first time, it will leave at
# most one byte in the buffer. stream.d (rd_ch_buffered, rd_ch_array_buffered)
# heavily depend on this.

local char const hex_table[] = "0123456789ABCDEF";

# Error, when a character cannot be converted to an encoding.
# fehler_unencodable(encoding);
nonreturning_function(global, fehler_unencodable,
                      (object encoding, chart ch)) {
  pushSTACK(code_char(ch)); # CHARSET-TYPE-ERROR slot DATUM
  pushSTACK(encoding); # CHARSET-TYPE-ERROR slot EXPECTED-TYPE
  pushSTACK(TheEncoding(encoding)->enc_charset);
  pushSTACK(ascii_char(hex_table[as_cint(ch)&0x0F]));
  pushSTACK(ascii_char(hex_table[(as_cint(ch)>>4)&0x0F]));
  pushSTACK(ascii_char(hex_table[(as_cint(ch)>>8)&0x0F]));
  pushSTACK(ascii_char(hex_table[(as_cint(ch)>>12)&0x0F]));
  if (as_cint(ch) < 0x10000)
    fehler(charset_type_error,
           GETTEXT("Character #\\u$$$$ cannot be represented in the character set ~"));
  else {
    pushSTACK(ascii_char(hex_table[(as_cint(ch)>>16)&0x0F]));
    pushSTACK(ascii_char(hex_table[(as_cint(ch)>>20)&0x0F]));
    fehler(charset_type_error,
           GETTEXT("Character #\\u00$$$$$$ cannot be represented in the character set ~"));
  }
}

# The range function for an encoding covering all of Unicode.
global object all_range (object encoding, uintL start, uintL end) {
  pushSTACK(code_char(as_chart(start))); pushSTACK(code_char(as_chart(end)));
  return stringof(2);
}

# The range function for an encoding covering the BMP of Unicode.
global object bmp_range (object encoding, uintL start, uintL end) {
  var uintL count = 0;
  if (start < 0x10000) {
    if (end >= 0x10000)
      end = 0xFFFF;
    pushSTACK(code_char(as_chart(start))); pushSTACK(code_char(as_chart(end)));
    count = 2;
  }
  return stringof(count);
}

# -----------------------------------------------------------------------------
#                              Unicode-16 encoding

# Unicode-16 encoding in two flavours:
# The big-endian format (files starting with 0xFE 0xFF),
# the little-endian format (files starting with 0xFF 0xFE).

# min. bytes per character = 2
# max. bytes per character = 2

global uintL uni16_mblen (object encoding, const uintB* src,
                          const uintB* srcend);
global void uni16be_mbstowcs (object encoding, object stream,
                              const uintB* *srcp, const uintB* srcend,
                              chart* *destp, chart* destend);
global void uni16le_mbstowcs (object encoding, object stream,
                              const uintB* *srcp, const uintB* srcend,
                              chart* *destp, chart* destend);
global uintL uni16_wcslen (object encoding, const chart* src,
                           const chart* srcend);
global void uni16be_wcstombs (object encoding, object stream,
                              const chart* *srcp, const chart* srcend,
                              uintB* *destp, uintB* destend);
global void uni16le_wcstombs (object encoding, object stream,
                              const chart* *srcp, const chart* srcend,
                              uintB* *destp, uintB* destend);

# Bytes to characters.

global uintL uni16_mblen (object encoding, const uintB* src,
                          const uintB* srcend) {
  return floor(srcend-src,2);
}

global void uni16be_mbstowcs (object encoding, object stream,
                              const uintB* *srcp, const uintB* srcend,
                              chart* *destp, chart* destend) {
  var const uintB* src = *srcp;
  var chart* dest = *destp;
  var uintL count = floor(srcend-src,2);
  if (count > destend-dest)
    count = destend-dest;
  if (count > 0) {
    dotimespL(count,count, {
      *dest++ = as_chart(((cint)src[0] << 8) | (cint)src[1]);
      src += 2;
    });
    *srcp = src;
    *destp = dest;
  }
}

global void uni16le_mbstowcs (object encoding, object stream,
                              const uintB* *srcp, const uintB* srcend,
                              chart* *destp, chart* destend) {
  var const uintB* src = *srcp;
  var chart* dest = *destp;
  var uintL count = floor(srcend-src,2);
  if (count > destend-dest)
    count = destend-dest;
  if (count > 0) {
    dotimespL(count,count, {
      *dest++ = as_chart((cint)src[0] | ((cint)src[1] << 8));
      src += 2;
    });
    *srcp = src;
    *destp = dest;
  }
}

# Characters to bytes.

global uintL uni16_wcslen (object encoding, const chart* src,
                           const chart* srcend) {
  var uintL count = srcend-src;
  var uintL result = 0;
  if (count > 0) {
    dotimespL(count,count, {
      var chart ch = *src++;
      if (as_cint(ch) < 0x10000)
        result += 2;
      else {
        var object action = TheEncoding(encoding)->enc_tombs_error;
        if (eq(action,S(Kignore))) {
        } else if (uint8_p(action)) {
          result++;
        } else if (!eq(action,S(Kerror))) {
          var chart c = char_code(action);
          if (as_cint(c) < 0x10000)
            result += 2;
        }
      }
    });
  }
  return result;
}

global void uni16be_wcstombs (object encoding, object stream,
                              const chart* *srcp, const chart* srcend,
                              uintB* *destp, uintB* destend) {
  var const chart* src = *srcp;
  var uintB* dest = *destp;
  var uintL scount = srcend-src;
  var uintL dcount = destend-dest;
  if (scount > 0 && dcount > 0) {
    do {
      var cint ch = as_cint(*src++); scount--;
      if (ch < 0x10000) {
        if (dcount < 2) break;
        dest[0] = (uintB)(ch>>8); dest[1] = (uintB)ch;
        dest += 2; dcount -= 2;
      } else {
        var object action = TheEncoding(encoding)->enc_tombs_error;
        if (eq(action,S(Kignore))) {
        } else if (uint8_p(action)) {
          *dest++ = I_to_uint8(action); dcount--;
        } else if (!eq(action,S(Kerror))) {
          var cint c = char_int(action);
          if (c < 0x10000) {
            if (dcount < 2) break;
            dest[0] = (uintB)(c>>8); dest[1] = (uintB)c;
            dest += 2; dcount -= 2;
          } else
            fehler_unencodable(encoding,as_chart(ch));
        } else
          fehler_unencodable(encoding,as_chart(ch));
      }
    } while (scount > 0 && dcount > 0);
    *srcp = src;
    *destp = dest;
  }
}

global void uni16le_wcstombs (object encoding, object stream,
                              const chart* *srcp, const chart* srcend,
                              uintB* *destp, uintB* destend) {
  var const chart* src = *srcp;
  var uintB* dest = *destp;
  var uintL scount = srcend-src;
  var uintL dcount = destend-dest;
  if (scount > 0 && dcount > 0) {
    do {
      var cint ch = as_cint(*src++); scount--;
      if (ch < 0x10000) {
        if (dcount < 2) break;
        dest[0] = (uintB)ch; dest[1] = (uintB)(ch>>8);
        dest += 2; dcount -= 2;
      } else {
        var object action = TheEncoding(encoding)->enc_tombs_error;
        if (eq(action,S(Kignore))) {
        } else if (uint8_p(action)) {
          *dest++ = I_to_uint8(action); dcount--;
        } else if (!eq(action,S(Kerror))) {
          var cint c = char_int(action);
          if (c < 0x10000) {
            if (dcount < 2) break;
            dest[0] = (uintB)c; dest[1] = (uintB)(c>>8);
            dest += 2; dcount -= 2;
          } else
            fehler_unencodable(encoding,as_chart(ch));
        } else
          fehler_unencodable(encoding,as_chart(ch));
      }
    } while (scount > 0 && dcount > 0);
    *srcp = src;
    *destp = dest;
  }
}

# -----------------------------------------------------------------------------
#                              Unicode-32 encoding

# Unicode-32 encoding in two flavours:
# The big-endian format,
# the little-endian format.

# min. bytes per character = 4
# max. bytes per character = 4

global uintL uni32be_mblen (object encoding, const uintB* src,
                            const uintB* srcend);
global uintL uni32le_mblen (object encoding, const uintB* src,
                            const uintB* srcend);
global void uni32be_mbstowcs (object encoding, object stream,
                              const uintB* *srcp, const uintB* srcend,
                              chart* *destp, chart* destend);
global void uni32le_mbstowcs (object encoding, object stream,
                              const uintB* *srcp, const uintB* srcend,
                              chart* *destp, chart* destend);
global uintL uni32_wcslen (object encoding, const chart* src,
                           const chart* srcend);
global void uni32be_wcstombs (object encoding, object stream,
                              const chart* *srcp, const chart* srcend,
                              uintB* *destp, uintB* destend);
global void uni32le_wcstombs (object encoding, object stream,
                              const chart* *srcp, const chart* srcend,
                              uintB* *destp, uintB* destend);

# Bytes to characters.

# Error when an invalid character was encountered.
# fehler_uni32_invalid(encoding,code);
nonreturning_function(local, fehler_uni32_invalid,
                      (object encoding, uint32 code)) {
  var uintC count;
  pushSTACK(TheEncoding(encoding)->enc_charset);
  dotimespC(count,8, {
    pushSTACK(ascii_char(hex_table[code&0x0F]));
    code = code>>4;
  });
  fehler(error,
         GETTEXT("character #x$$$$$$$$ in ~ conversion, not an UTF-32 character"));
}

global uintL uni32be_mblen (object encoding, const uintB* src,
                            const uintB* srcend) {
  if (!eq(TheEncoding(encoding)->enc_towcs_error,S(Kignore)))
    return floor(srcend-src,4);
  else {
    var uintL count = floor(srcend-src,4);
    var uintL result = 0;
    dotimesL(count,count, {
      var uint32 ch =
        ((uint32)src[0] << 24) | ((uint32)src[1] << 16)
        | ((uint32)src[2] << 8) | (uint32)src[3];
      if (ch < char_code_limit)
        result++;
      src += 4;
    });
    return result;
  }
}

global uintL uni32le_mblen (object encoding, const uintB* src,
                            const uintB* srcend) {
  if (!eq(TheEncoding(encoding)->enc_towcs_error,S(Kignore)))
    return floor(srcend-src,4);
  else {
    var uintL count = floor(srcend-src,4);
    var uintL result = 0;
    dotimesL(count,count, {
      var uint32 ch =
        (uint32)src[0] | ((uint32)src[1] << 8)
        | ((uint32)src[2] << 16) | ((uint32)src[3] << 24);
      if (ch < char_code_limit)
        result++;
      src += 4;
    });
    return result;
  }
}

global void uni32be_mbstowcs (object encoding, object stream,
                              const uintB* *srcp, const uintB* srcend,
                              chart* *destp, chart* destend) {
  var const uintB* src = *srcp;
  var chart* dest = *destp;
  var uintL scount = floor(srcend-src,4);
  var uintL dcount = destend-dest;
  if (scount > 0 && dcount > 0) {
    do {
      var uint32 ch =
        ((uint32)src[0] << 24) | ((uint32)src[1] << 16)
        | ((uint32)src[2] << 8) | (uint32)src[3];
      if (ch < char_code_limit) {
        *dest++ = as_chart(ch); dcount--;
      } else {
        var object action = TheEncoding(encoding)->enc_towcs_error;
        if (eq(action,S(Kignore))) {
        } else if (eq(action,S(Kerror))) {
          fehler_uni32_invalid(encoding,ch);
        } else {
          *dest++ = char_code(action); dcount--;
        }
      }
      src += 4; scount--;
    } while (scount > 0 && dcount > 0);
    *srcp = src;
    *destp = dest;
  }
}

global void uni32le_mbstowcs (object encoding, object stream,
                              const uintB* *srcp, const uintB* srcend,
                              chart* *destp, chart* destend) {
  var const uintB* src = *srcp;
  var chart* dest = *destp;
  var uintL scount = floor(srcend-src,4);
  var uintL dcount = destend-dest;
  if (scount > 0 && dcount > 0) {
    do {
      var uint32 ch =
        (uint32)src[0] | ((uint32)src[1] << 8)
        | ((uint32)src[2] << 16) | ((uint32)src[3] << 24);
      if (ch < char_code_limit) {
        *dest++ = as_chart(ch); dcount--;
      } else {
        var object action = TheEncoding(encoding)->enc_towcs_error;
        if (eq(action,S(Kignore))) {
        } else if (eq(action,S(Kerror))) {
          fehler_uni32_invalid(encoding,ch);
        } else {
          *dest++ = char_code(action); dcount--;
        }
      }
      src += 4; scount--;
    } while (scount > 0 && dcount > 0);
    *srcp = src;
    *destp = dest;
  }
}

# Characters to bytes.

global uintL uni32_wcslen (object encoding, const chart* src,
                           const chart* srcend) {
  return (srcend-src)*4;
}

global void uni32be_wcstombs (object encoding, object stream,
                              const chart* *srcp, const chart* srcend,
                              uintB* *destp, uintB* destend) {
  var const chart* src = *srcp;
  var uintB* dest = *destp;
  var uintL count = floor(destend-dest,4);
  if (count > srcend-src)
    count = srcend-src;
  if (count > 0) {
    dotimespL(count,count, {
      var cint ch = as_cint(*src++);
      dest[0] = 0; dest[1] = (uintB)(ch>>16);
      dest[2] = (uintB)(ch>>8); dest[3] = (uintB)ch;
      dest += 4;
    });
    *srcp = src;
    *destp = dest;
  }
}

global void uni32le_wcstombs (object encoding, object stream,
                              const chart* *srcp, const chart* srcend,
                              uintB* *destp, uintB* destend) {
  var const chart* src = *srcp;
  var uintB* dest = *destp;
  var uintL count = floor(destend-dest,4);
  if (count > srcend-src)
    count = srcend-src;
  if (count > 0) {
    dotimespL(count,count, {
      var cint ch = as_cint(*src++);
      dest[0] = (uintB)ch; dest[1] = (uintB)(ch>>8);
      dest[2] = (uintB)(ch>>16); dest[3] = 0;
      dest += 4;
    });
    *srcp = src;
    *destp = dest;
  }
}

# -----------------------------------------------------------------------------
#                                UTF-8 encoding

# See http://www.stonehand.com/unicode/standard/fss-utf.html
# or  Linux 2.0.x, file linux/fs/nls.c
#                   cmask  cval  shift     maxval           bits
#  1 byte sequence   0x80  0x00   0*6         0x7F  0XXXXXXX
#  2 byte sequence   0xE0  0xC0   1*6        0x7FF  110XXXXX 10XXXXXX
#  3 byte sequence   0xF0  0xE0   2*6       0xFFFF  1110XXXX 10XXXXXX 10XXXXXX
#  4 byte sequence   0xF8  0xF0   3*6     0x1FFFFF  11110XXX 10XXXXXX 10XXXXXX 10XXXXXX
#  5 byte sequence   0xFC  0xF8   4*6    0x3FFFFFF  111110XX 10XXXXXX 10XXXXXX 10XXXXXX 10XXXXXX
#  6 byte sequence   0xFE  0xFC   5*6   0x7FFFFFFF  1111110X 10XXXXXX 10XXXXXX 10XXXXXX 10XXXXXX 10XXXXXX
#
# We support only 21-bit Unicode characters, i.e. those which can be encoded
# with at most 4 bytes. Characters outside this range give an error.
# Spurious bytes of the form 10XXXXXX are ignored. (This resync feature is one
# of the benefits of the UTF encoding.)

# min. bytes per character = 1
# max. bytes per character = 4

global uintL utf8_mblen (object encoding, const uintB* src,
                         const uintB* srcend);
global void utf8_mbstowcs (object encoding, object stream, const uintB* *srcp,
                           const uintB* srcend, chart* *destp, chart* destend);
global uintL utf8_wcslen (object encoding, const chart* src,
                          const chart* srcend);
global void utf8_wcstombs (object encoding, object stream, const chart* *srcp,
                           const chart* srcend, uintB* *destp, uintB* destend);

# Bytes to characters.

# Error when an invalid 1-byte sequence was encountered.
# fehler_utf8_invalid1(encoding,b1);
nonreturning_function(local, fehler_utf8_invalid1,
                      (object encoding, uintB b1)) {
  pushSTACK(TheEncoding(encoding)->enc_charset);
  pushSTACK(ascii_char(hex_table[b1&0x0F]));
  pushSTACK(ascii_char(hex_table[(b1>>4)&0x0F]));
  fehler(error,GETTEXT("invalid byte #x$$ in ~ conversion, not a Unicode-16"));
}

# Error when an invalid 2-byte sequence was encountered.
# fehler_utf8_invalid2(encoding,b1,b2);
nonreturning_function(local, fehler_utf8_invalid2,
                      (object encoding, uintB b1, uintB b2)) {
  pushSTACK(TheEncoding(encoding)->enc_charset);
  pushSTACK(ascii_char(hex_table[b2&0x0F]));
  pushSTACK(ascii_char(hex_table[(b2>>4)&0x0F]));
  pushSTACK(ascii_char(hex_table[b1&0x0F]));
  pushSTACK(ascii_char(hex_table[(b1>>4)&0x0F]));
  fehler(error,GETTEXT("invalid byte sequence #x$$ #x$$ in ~ conversion"));
}

# Error when an invalid 3-byte sequence was encountered.
# fehler_utf8_invalid3(encoding,b1,b2,b3);
nonreturning_function(local, fehler_utf8_invalid3,
                      (object encoding, uintB b1, uintB b2, uintB b3)) {
  pushSTACK(TheEncoding(encoding)->enc_charset);
  pushSTACK(ascii_char(hex_table[b3&0x0F]));
  pushSTACK(ascii_char(hex_table[(b3>>4)&0x0F]));
  pushSTACK(ascii_char(hex_table[b2&0x0F]));
  pushSTACK(ascii_char(hex_table[(b2>>4)&0x0F]));
  pushSTACK(ascii_char(hex_table[b1&0x0F]));
  pushSTACK(ascii_char(hex_table[(b1>>4)&0x0F]));
  fehler(error,
         GETTEXT("invalid byte sequence #x$$ #x$$ #x$$ in ~ conversion"));
}

# Error when an invalid 4-byte sequence was encountered.
# fehler_utf8_invalid4(encoding,b1,b2,b3,b4);
nonreturning_function(local, fehler_utf8_invalid4,
                      (object encoding, uintB b1, uintB b2, uintB b3, uintB b4)) {
  pushSTACK(TheEncoding(encoding)->enc_charset);
  pushSTACK(ascii_char(hex_table[b4&0x0F]));
  pushSTACK(ascii_char(hex_table[(b4>>4)&0x0F]));
  pushSTACK(ascii_char(hex_table[b3&0x0F]));
  pushSTACK(ascii_char(hex_table[(b3>>4)&0x0F]));
  pushSTACK(ascii_char(hex_table[b2&0x0F]));
  pushSTACK(ascii_char(hex_table[(b2>>4)&0x0F]));
  pushSTACK(ascii_char(hex_table[b1&0x0F]));
  pushSTACK(ascii_char(hex_table[(b1>>4)&0x0F]));
  fehler(error,
         GETTEXT("invalid byte sequence #x$$ #x$$ #x$$ #x$$ in ~ conversion"));
}

global uintL utf8_mblen (object encoding, const uintB* src,
                         const uintB* srcend) {
  var uintL count = 0;
  while (src < srcend) {
    var uintB c = src[0];
    if (c < 0x80) { # 1 byte sequence
      src += 1;
      count++;
      continue;
    }
    if (c < 0xC0) {
      src++; continue; # skip spurious 10XXXXXX byte
    }
    if (c < 0xE0) { # 2 byte sequence
      if (src+2 > srcend) break;
      if (((src[1] ^ 0x80) < 0x40)
          && (c >= 0xC2)) {
        src += 2;
        count++;
        continue;
      }
      {
        var object action = TheEncoding(encoding)->enc_towcs_error;
        if (eq(action,S(Kignore))) {
          src += 2; continue;
        } else if (eq(action,S(Kerror))) {
          fehler_utf8_invalid2(encoding,c,src[1]);
        } else {
          src += 2; count++; continue;
        }
      }
    }
    if (c < 0xF0) { # 3 byte sequence
      if (src+3 > srcend) break;
      if (((src[1] ^ 0x80) < 0x40) && ((src[2] ^ 0x80) < 0x40)
          && (c >= 0xE1 || src[1] >= 0xA0)
          && (c != 0xED || src[1] < 0xA0)) {
        src += 3;
        count++;
        continue;
      }
      {
        var object action = TheEncoding(encoding)->enc_towcs_error;
        if (eq(action,S(Kignore))) {
          src += 3; continue;
        } else if (eq(action,S(Kerror))) {
          fehler_utf8_invalid3(encoding,c,src[1],src[2]);
        } else {
          src += 3; count++; continue;
        }
      }
    }
    if (c < 0xF8) { # 4 byte sequence
      if (src+4 > srcend) break;
      if (((src[1] ^ 0x80) < 0x40) && ((src[2] ^ 0x80) < 0x40)
          && ((src[3] ^ 0x80) < 0x40)
          && (c >= 0xF1 || src[1] >= 0x90)) {
        src += 4;
        count++;
        continue;
      }
      {
        var object action = TheEncoding(encoding)->enc_towcs_error;
        if (eq(action,S(Kignore))) {
          src += 4; continue;
        } else if (eq(action,S(Kerror))) {
          fehler_utf8_invalid4(encoding,c,src[1],src[2],src[3]);
        } else {
          src += 4; count++; continue;
        }
      }
    }
    {
      var object action = TheEncoding(encoding)->enc_towcs_error;
      if (eq(action,S(Kignore))) {
        src += 1; continue;
      } else if (eq(action,S(Kerror))) {
        fehler_utf8_invalid1(encoding,c);
      } else {
        src += 1; count++; continue;
      }
    }
  }
  return count;
}

global void utf8_mbstowcs (object encoding, object stream, const uintB* *srcp,
                           const uintB* srcend, chart* *destp,
                           chart* destend) {
  var const uintB* src = *srcp;
  var chart* dest = *destp;
  while (src < srcend) {
    var uintB c = src[0];
    if (c < 0x80) { # 1 byte sequence
      if (dest == destend) break;
      *dest++ = as_chart((cint)c);
      src += 1;
      continue;
    }
    if (c < 0xC0) {
      src++; continue; # skip spurious 10XXXXXX byte
    }
    if (dest == destend) break;
    if (c < 0xE0) { # 2 byte sequence
      if (src+2 > srcend) break;
      if (((src[1] ^ 0x80) < 0x40)
          && (c >= 0xC2)) {
        *dest++ = as_chart(((cint)(c & 0x1F) << 6) | (cint)(src[1] ^ 0x80));
        src += 2;
        continue;
      }
      {
        var object action = TheEncoding(encoding)->enc_towcs_error;
        if (eq(action,S(Kignore))) {
          src += 2; continue;
        } else if (eq(action,S(Kerror))) {
          fehler_utf8_invalid2(encoding,c,src[1]);
        } else {
          src += 2; *dest++ = char_code(action); continue;
        }
      }
    }
    if (c < 0xF0) { # 3 byte sequence
      if (src+3 > srcend) break;
      if (((src[1] ^ 0x80) < 0x40) && ((src[2] ^ 0x80) < 0x40)
          && (c >= 0xE1 || src[1] >= 0xA0)
          && (c != 0xED || src[1] < 0xA0)) {
        *dest++ = as_chart(((cint)(c & 0x0F) << 12) |
                           ((cint)(src[1] ^ 0x80) << 6) |
                           (cint)(src[2] ^ 0x80));
        src += 3;
        continue;
      }
      {
        var object action = TheEncoding(encoding)->enc_towcs_error;
        if (eq(action,S(Kignore))) {
          src += 3; continue;
        } else if (eq(action,S(Kerror))) {
          fehler_utf8_invalid3(encoding,c,src[1],src[2]);
        } else {
          src += 3; *dest++ = char_code(action); continue;
        }
      }
    }
    if (c < 0xF8) { # 4 byte sequence
      if (src+4 > srcend) break;
      if (((src[1] ^ 0x80) < 0x40) && ((src[2] ^ 0x80) < 0x40)
          && ((src[3] ^ 0x80) < 0x40)
          && (c >= 0xF1 || src[1] >= 0x90)) {
        *dest++ = as_chart(((cint)(c & 0x07) << 18) |
                           ((cint)(src[1] ^ 0x80) << 12) |
                           ((cint)(src[2] ^ 0x80) << 6) |
                           (cint)(src[3] ^ 0x80));
        src += 4;
        continue;
      }
      {
        var object action = TheEncoding(encoding)->enc_towcs_error;
        if (eq(action,S(Kignore))) {
          src += 4; continue;
        } else if (eq(action,S(Kerror))) {
          fehler_utf8_invalid4(encoding,c,src[1],src[2],src[3]);
        } else {
          src += 4; *dest++ = char_code(action); continue;
        }
      }
    }
    {
      var object action = TheEncoding(encoding)->enc_towcs_error;
      if (eq(action,S(Kignore))) {
        src += 1; continue;
      } else if (eq(action,S(Kerror))) {
        fehler_utf8_invalid1(encoding,c);
      } else {
        src += 1; *dest++ = char_code(action); continue;
      }
    }
  }
  *srcp = src;
  *destp = dest;
}

# Characters to bytes.

global uintL utf8_wcslen (object encoding, const chart* src,
                          const chart* srcend) {
  var uintL destlen = 0;
  while (src < srcend) {
    var cint ch = as_cint(*src++);
    destlen += (ch < 0x80 ? 1 : ch < 0x800 ? 2 : 3);
  }
  return destlen;
}

global void utf8_wcstombs (object encoding, object stream, const chart* *srcp,
                           const chart* srcend, uintB* *destp,
                           uintB* destend) {
  var const chart* src = *srcp;
  var uintB* dest = *destp;
  while (src < srcend) {
    var cint ch = as_cint(*src);
    var uintL count = (ch < 0x80 ? 1 : ch < 0x800 ? 2 : 3);
    if (dest+count > destend) break;
    src++;
    if (ch < 0x80) { # 1 byte sequence
      *dest++ = ch;
    } else if (ch < 0x800) { # 2 byte sequence
      *dest++ = 0xC0 | (ch >> 6);
      *dest++ = 0x80 | (ch & 0x3F);
    } else if (ch < 0x10000) { # 3 byte sequence
      *dest++ = 0xE0 | (ch >> 12);
      *dest++ = 0x80 | ((ch >> 6) & 0x3F);
      *dest++ = 0x80 | (ch & 0x3F);
    } else { # ch < 0x110000, 4 byte sequence
      *dest++ = 0xF0 | (ch >> 18);
      *dest++ = 0x80 | ((ch >> 12) & 0x3F);
      *dest++ = 0x80 | ((ch >> 6) & 0x3F);
      *dest++ = 0x80 | (ch & 0x3F);
    }
  }
  *srcp = src;
  *destp = dest;
}

# -----------------------------------------------------------------------------
#                                Java encoding

# This is ISO 8859-1 with \uXXXX escape sequences, denoting Unicode characters.
# See the Java Language Specification.
# Characters outside the BMP are represented by two consecutive \uXXXX escape
# sequences, like UTF-16. Example:
#   $ printf '\U00102345\n' | native2ascii -encoding UTF-8
#   \udbc8\udf45
#
# Thick is quick&dirty: The text is supposed not to contain \u except as part
# of \uXXXX escape sequences.

# min. bytes per character = 1
# max. bytes per character = 12

global uintL java_mblen (object encoding, const uintB* src,
                         const uintB* srcend);
global void java_mbstowcs (object encoding, object stream, const uintB* *srcp,
                           const uintB* srcend, chart* *destp, chart* destend);
global uintL java_wcslen (object encoding, const chart* src,
                          const chart* srcend);
global void java_wcstombs (object encoding, object stream, const chart* *srcp,
                           const chart* srcend, uintB* *destp, uintB* destend);

# Bytes to characters.

global uintL java_mblen (object encoding, const uintB* src,
                         const uintB* srcend) {
  var uintL count = 0;
  while (src < srcend) {
    var uintB c;
    var cint ch;
    if (src[0] != '\\') {
      src += 1;
      count++;
      continue;
    }
    if (src+2 > srcend) break;
    if (src[1] != 'u') {
      src += 1;
      count++;
      continue;
    }
    if (src+3 > srcend) break;
    c = src[2];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 2; # skip incomplete \u sequence
      continue;
    }
    ch = (cint)c << 12;
    if (src+4 > srcend) break;
    c = src[3];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 3; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c << 8;
    if (src+5 > srcend) break;
    c = src[4];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 4; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c << 4;
    if (src+6 > srcend) break;
    c = src[5];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 5; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c;
    if (ch < char_code_limit && !(ch >= 0xd800 && ch < 0xe000)) {
      src += 6; # complete \u sequence
      count++;
      continue;
    }
    if (!(ch >= 0xd800 && ch < 0xdc00)) {
      src += 6; # skip invalid \u sequence
      continue;
    }
    var cint ch1 = ch;
    if (src+7 > srcend) break;
    if (src[6] != '\\') {
      src += 6; # skip incomplete \u sequence
      continue;
    }
    if (src+8 > srcend) break;
    if (src[7] != 'u') {
      src += 6; # skip incomplete \u sequence
      continue;
    }
    if (src+9 > srcend) break;
    c = src[8];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 8; # skip incomplete \u sequence
      continue;
    }
    ch = (cint)c << 12;
    if (src+10 > srcend) break;
    c = src[9];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 9; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c << 8;
    if (src+11 > srcend) break;
    c = src[10];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 10; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c << 4;
    if (src+12 > srcend) break;
    c = src[11];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 11; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c;
    if (ch >= 0xdc00 && ch < 0xe000) {
      ch = 0x10000 + ((ch1 - 0xd800) << 10) + (ch - 0xdc00);
      if (ch < char_code_limit) {
        src += 12; # complete \u sequence
        count++;
        continue;
      }
    }
    src += 6; # skip invalid \u sequence
    continue;
  }
  return count;
}

global void java_mbstowcs (object encoding, object stream, const uintB* *srcp,
                           const uintB* srcend, chart* *destp,
                           chart* destend) {
  var const uintB* src = *srcp;
  var chart* dest = *destp;
  while (src < srcend) {
    var uintB c;
    var cint ch;
    c = src[0];
    if (c != '\\') {
      if (dest==destend) break;
      *dest++ = as_chart((cint)c);
      src += 1;
      continue;
    }
    if (src+2 > srcend) break;
    if (src[1] != 'u') {
      if (dest==destend) break;
      *dest++ = as_chart((cint)c);
      src += 1;
      continue;
    }
    if (src+3 > srcend) break;
    c = src[2];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 2; # skip incomplete \u sequence
      continue;
    }
    ch = (cint)c << 12;
    if (src+4 > srcend) break;
    c = src[3];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 3; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c << 8;
    if (src+5 > srcend) break;
    c = src[4];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 4; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c << 4;
    if (src+6 > srcend) break;
    c = src[5];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 5; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c;
    if (ch < char_code_limit && !(ch >= 0xd800 && ch < 0xe000)) {
      if (dest==destend) break;
      *dest++ = as_chart(ch);
      src += 6; # complete \u sequence
      continue;
    }
    if (!(ch >= 0xd800 && ch < 0xdc00)) {
      src += 6; # skip invalid \u sequence
      continue;
    }
    var cint ch1 = ch;
    if (src+7 > srcend) break;
    if (src[6] != '\\') {
      src += 6; # skip incomplete \u sequence
      continue;
    }
    if (src+8 > srcend) break;
    if (src[7] != 'u') {
      src += 6; # skip incomplete \u sequence
      continue;
    }
    if (src+9 > srcend) break;
    c = src[8];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 8; # skip incomplete \u sequence
      continue;
    }
    ch = (cint)c << 12;
    if (src+10 > srcend) break;
    c = src[9];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 9; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c << 8;
    if (src+11 > srcend) break;
    c = src[10];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 10; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c << 4;
    if (src+12 > srcend) break;
    c = src[11];
    if (c >= '0' && c <= '9') { c -= '0'; }
    else if (c >= 'A' && c <= 'F') { c -= 'A'-10; }
    else if (c >= 'a' && c <= 'f') { c -= 'a'-10; }
    else {
      src += 11; # skip incomplete \u sequence
      continue;
    }
    ch |= (cint)c;
    if (ch >= 0xdc00 && ch < 0xe000) {
      ch = 0x10000 + ((ch1 - 0xd800) << 10) + (ch - 0xdc00);
      if (ch < char_code_limit) {
        if (dest==destend) break;
        *dest++ = as_chart(ch);
        src += 12; # complete \u sequence
        continue;
      }
    }
    src += 6; # skip invalid \u sequence
    continue;
  }
  *srcp = src;
  *destp = dest;
}

# Characters to bytes.

global uintL java_wcslen (object encoding, const chart* src,
                          const chart* srcend) {
  var uintL destlen = 0;
  while (src < srcend) {
    var cint ch = as_cint(*src++);
    destlen += (ch < 0x80 ? 1 : ch < 0x10000 ? 6 : 12);
  }
  return destlen;
}

global void java_wcstombs (object encoding, object stream, const chart* *srcp,
                           const chart* srcend, uintB* *destp,
                           uintB* destend) {
  var const chart* src = *srcp;
  var uintB* dest = *destp;
  while (src < srcend) {
    local char const hex_table[] = "0123456789abcdef"; # lowercase!
    var cint ch = as_cint(*src);
    var uintL count = (ch < 0x80 ? 1 : ch < 0x10000 ? 6 : 12);
    if (dest+count > destend) break;
    src++;
    if (ch < 0x80) { # 1 byte sequence
      *dest++ = ch;
    } else if (ch < 0x10000) { # 6 byte sequence
      *dest++ = '\\';
      *dest++ = 'u';
      *dest++ = hex_table[(ch>>12)&0x0F];
      *dest++ = hex_table[(ch>>8)&0x0F];
      *dest++ = hex_table[(ch>>4)&0x0F];
      *dest++ = hex_table[ch&0x0F];
    } else { # 12 byte sequence
      var cint ch1 = 0xD800 + ((ch - 0x10000) >> 10);
      var cint ch2 = 0xDC00 + ((ch - 0x10000) & 0x3FF);
      *dest++ = '\\';
      *dest++ = 'u';
      *dest++ = hex_table[(ch1>>12)&0x0F];
      *dest++ = hex_table[(ch1>>8)&0x0F];
      *dest++ = hex_table[(ch1>>4)&0x0F];
      *dest++ = hex_table[ch1&0x0F];
      *dest++ = '\\';
      *dest++ = 'u';
      *dest++ = hex_table[(ch2>>12)&0x0F];
      *dest++ = hex_table[(ch2>>8)&0x0F];
      *dest++ = hex_table[(ch2>>4)&0x0F];
      *dest++ = hex_table[ch2&0x0F];
    }
  }
  *srcp = src;
  *destp = dest;
}

# -----------------------------------------------------------------------------
#                            8-bit NLS characters sets

# min. bytes per character = 1
# max. bytes per character = 1

typedef struct nls_table {
  const char* charset;
  const unsigned char* const* page_uni2charset;  # UCS-2 to 8-bit table
  const unsigned short* charset2uni;             # 8-bit to UCS-2 table
  int is_ascii_extension;
}
  #if defined(NO_TYPECODES) && (alignment_long < 4) && defined(GNU)
    # Force all XPSEUDODATAs to be allocated with a 4-byte alignment.
    # GC needs this.
    __attribute__ ((aligned (4)))
  #endif
  nls_table;

static const unsigned char nopage[256] = {
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x00-0x07 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x08-0x0f */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x10-0x17 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x18-0x1f */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x20-0x27 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x28-0x2f */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x30-0x37 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x38-0x3f */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x40-0x47 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x48-0x4f */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x50-0x57 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x58-0x5f */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x60-0x67 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x68-0x6f */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x70-0x77 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x78-0x7f */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x80-0x87 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x88-0x8f */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x90-0x97 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x98-0x9f */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xa0-0xa7 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xa8-0xaf */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xb0-0xb7 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xb8-0xbf */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xc0-0xc7 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xc8-0xcf */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xd0-0xd7 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xd8-0xdf */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xe0-0xe7 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xe8-0xef */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xf0-0xf7 */
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  /* 0xf8-0xff */
};

#include "nls_ascii.c"
#include "nls_iso8859_1.c"
#include "nls_iso8859_2.c"
#include "nls_iso8859_3.c"
#include "nls_iso8859_4.c"
#include "nls_iso8859_5.c"
#include "nls_iso8859_6.c"
#include "nls_iso8859_7.c"
#include "nls_iso8859_8.c"
#include "nls_iso8859_9.c"
#include "nls_iso8859_10.c"
#include "nls_iso8859_13.c"
#include "nls_iso8859_14.c"
#include "nls_iso8859_15.c"
#include "nls_iso8859_16.c"
#include "nls_koi8_r.c"
#include "nls_koi8_u.c"
#include "nls_mac_arabic.c"
#include "nls_mac_centraleurope.c"
#include "nls_mac_croatian.c"
#include "nls_mac_cyrillic.c"
#include "nls_mac_dingbat.c"
#include "nls_mac_greek.c"
#include "nls_mac_hebrew.c"
#include "nls_mac_iceland.c"
#include "nls_mac_roman.c"
#include "nls_mac_romania.c"
#include "nls_mac_symbol.c"
#include "nls_mac_thai.c"
#include "nls_mac_turkish.c"
#include "nls_mac_ukraine.c"
#include "nls_cp437_ms.c"
#include "nls_cp437_ibm.c"
#include "nls_cp737.c"
#include "nls_cp775.c"
#include "nls_cp850.c"
#include "nls_cp852_ms.c"
#include "nls_cp852_ibm.c"
#include "nls_cp855.c"
#include "nls_cp857.c"
#include "nls_cp860_ms.c"
#include "nls_cp860_ibm.c"
#include "nls_cp861_ms.c"
#include "nls_cp861_ibm.c"
#include "nls_cp862_ms.c"
#include "nls_cp862_ibm.c"
#include "nls_cp863_ms.c"
#include "nls_cp863_ibm.c"
#include "nls_cp864_ms.c"
#include "nls_cp864_ibm.c"
#include "nls_cp865_ms.c"
#include "nls_cp865_ibm.c"
#include "nls_cp866.c"
#include "nls_cp869_ms.c"
#include "nls_cp869_ibm.c"
#include "nls_cp874_ms.c"
#include "nls_cp874_ibm.c"
#include "nls_cp1250.c"
#include "nls_cp1251.c"
#include "nls_cp1252.c"
#include "nls_cp1253.c"
#include "nls_cp1254.c"
#include "nls_cp1255.c"
#include "nls_cp1256.c"
#include "nls_cp1257.c"
#include "nls_cp1258.c"
#include "nls_hp_roman8.c"
#include "nls_nextstep.c"
#include "nls_jisx0201.c"

#define nls_first_sym  S(ascii)
#define nls_last_sym  S(jisx0201)
#define nls_num_encodings  (&symbol_tab_data.S_jisx0201 - &symbol_tab_data.S_ascii + 1)

static const nls_table * const nls_tables[] = {
  &nls_ascii_table,
  &nls_iso8859_1_table,
  &nls_iso8859_2_table,
  &nls_iso8859_3_table,
  &nls_iso8859_4_table,
  &nls_iso8859_5_table,
  &nls_iso8859_6_table,
  &nls_iso8859_7_table,
  &nls_iso8859_8_table,
  &nls_iso8859_9_table,
  &nls_iso8859_10_table,
  &nls_iso8859_13_table,
  &nls_iso8859_14_table,
  &nls_iso8859_15_table,
  &nls_iso8859_16_table,
  &nls_koi8_r_table,
  &nls_koi8_u_table,
  &nls_mac_arabic_table,
  &nls_mac_centraleurope_table,
  &nls_mac_croatian_table,
  &nls_mac_cyrillic_table,
  &nls_mac_dingbat_table,
  &nls_mac_greek_table,
  &nls_mac_hebrew_table,
  &nls_mac_iceland_table,
  &nls_mac_roman_table,
  &nls_mac_romania_table,
  &nls_mac_symbol_table,
  &nls_mac_thai_table,
  &nls_mac_turkish_table,
  &nls_mac_ukraine_table,
  &nls_cp437_ms_table,
  &nls_cp437_ibm_table,
  &nls_cp737_table,
  &nls_cp775_table,
  &nls_cp850_table,
  &nls_cp852_ms_table,
  &nls_cp852_ibm_table,
  &nls_cp855_table,
  &nls_cp857_table,
  &nls_cp860_ms_table,
  &nls_cp860_ibm_table,
  &nls_cp861_ms_table,
  &nls_cp861_ibm_table,
  &nls_cp862_ms_table,
  &nls_cp862_ibm_table,
  &nls_cp863_ms_table,
  &nls_cp863_ibm_table,
  &nls_cp864_ms_table,
  &nls_cp864_ibm_table,
  &nls_cp865_ms_table,
  &nls_cp865_ibm_table,
  &nls_cp866_table,
  &nls_cp869_ms_table,
  &nls_cp869_ibm_table,
  &nls_cp874_ms_table,
  &nls_cp874_ibm_table,
  &nls_cp1250_table,
  &nls_cp1251_table,
  &nls_cp1252_table,
  &nls_cp1253_table,
  &nls_cp1254_table,
  &nls_cp1255_table,
  &nls_cp1256_table,
  &nls_cp1257_table,
  &nls_cp1258_table,
  &nls_hp_roman8_table,
  &nls_nextstep_table,
  &nls_jisx0201_table,
};

global uintL nls_mblen (object encoding, const uintB* src,
                        const uintB* srcend);
global void nls_mbstowcs (object encoding, object stream, const uintB* *srcp,
                          const uintB* srcend, chart* *destp, chart* destend);
global uintL nls_asciiext_mblen (object encoding, const uintB* src,
                                 const uintB* srcend);
global void nls_asciiext_mbstowcs (object encoding, object stream,
                                   const uintB* *srcp, const uintB* srcend,
                                   chart* *destp, chart* destend);
global uintL nls_wcslen (object encoding, const chart* src,
                         const chart* srcend);
global void nls_wcstombs (object encoding, object stream, const chart* *srcp,
                          const chart* srcend, uintB* *destp, uintB* destend);
global uintL nls_asciiext_wcslen (object encoding, const chart* src,
                                  const chart* srcend);
global void nls_asciiext_wcstombs (object encoding, object stream,
                                   const chart* *srcp, const chart* srcend,
                                   uintB* *destp, uintB* destend);
global object nls_range (object encoding, uintL start, uintL end);

# Bytes to characters.

# Error when an invalid byte was encountered.
# fehler_nls_invalid(encoding,b);
nonreturning_function(local, fehler_nls_invalid, (object encoding, uintB b)) {
  pushSTACK(TheEncoding(encoding)->enc_charset);
  pushSTACK(ascii_char(hex_table[b&0x0F]));
  pushSTACK(ascii_char(hex_table[(b>>4)&0x0F]));
  fehler(error,GETTEXT("invalid byte #x$$ in ~ conversion"));
}

global uintL nls_mblen (object encoding, const uintB* src,
                        const uintB* srcend) {
  if (!eq(TheEncoding(encoding)->enc_towcs_error,S(Kignore)))
    return (srcend-src);
  else {
    var uintL count = srcend-src;
    var uintL result = 0;
    if (count > 0) {
      var const nls_table* table =
        (const nls_table*) TheMachine(TheEncoding(encoding)->enc_table);
      var const unsigned short* cvtable = table->charset2uni;
      dotimespL(count,count, {
        if (!(cvtable[*src++] == 0xFFFD))
          result++;
      });
    }
    return result;
  }
}

global void nls_mbstowcs (object encoding, object stream, const uintB* *srcp,
                          const uintB* srcend, chart* *destp, chart* destend) {
  var const uintB* src = *srcp;
  var chart* dest = *destp;
  var uintL count = destend-dest;
  if (count > srcend-src)
    count = srcend-src;
  if (count > 0) {
    var const nls_table* table =
      (const nls_table*) TheMachine(TheEncoding(encoding)->enc_table);
    var const unsigned short* cvtable = table->charset2uni;
    dotimespL(count,count, {
      var uintB b = *src++;
      var cint ch = cvtable[b];
      if (!(ch == 0xFFFD)) {
        *dest++ = as_chart(ch);
      } else {
        var object action = TheEncoding(encoding)->enc_towcs_error;
        if (eq(action,S(Kignore))) {
        } else if (eq(action,S(Kerror))) {
          fehler_nls_invalid(encoding,b);
        } else {
          *dest++ = char_code(action);
        }
      }
    });
    *srcp = src;
    *destp = dest;
  }
}

# Same thing, specially optimized for ASCII extensions.

global uintL nls_asciiext_mblen (object encoding, const uintB* src,
                                 const uintB* srcend) {
  if (!eq(TheEncoding(encoding)->enc_towcs_error,S(Kignore)))
    return (srcend-src);
  else {
    var uintL count = srcend-src;
    var uintL result = 0;
    if (count > 0) {
      var const nls_table* table =
        (const nls_table*) TheMachine(TheEncoding(encoding)->enc_table);
      var const unsigned short* cvtable = table->charset2uni;
      dotimespL(count,count, {
        var uintB b = *src++;
        if ((b < 0x80) || !(cvtable[b] == 0xFFFD))
          result++;
      });
    }
    return result;
  }
}

global void nls_asciiext_mbstowcs (object encoding, object stream,
                                   const uintB* *srcp, const uintB* srcend,
                                   chart* *destp, chart* destend) {
  var const uintB* src = *srcp;
  var chart* dest = *destp;
  var uintL count = destend-dest;
  if (count > srcend-src)
    count = srcend-src;
  if (count > 0) {
    var const nls_table* table =
      (const nls_table*) TheMachine(TheEncoding(encoding)->enc_table);
    var const unsigned short* cvtable = table->charset2uni;
    dotimespL(count,count, {
      var uintB b = *src++;
      if (b < 0x80) {
        *dest++ = as_chart((cint)b); # avoid memory reference (big speedup!)
      } else {
        var cint ch = cvtable[b];
        if (!(ch == 0xFFFD)) {
          *dest++ = as_chart(ch);
        } else {
          var object action = TheEncoding(encoding)->enc_towcs_error;
          if (eq(action,S(Kignore))) {
          } else if (eq(action,S(Kerror))) {
            fehler_nls_invalid(encoding,b);
          } else {
            *dest++ = char_code(action);
          }
        }
      }
    });
    *srcp = src;
    *destp = dest;
  }
}

# Characters to bytes.

global uintL nls_wcslen (object encoding, const chart* src,
                         const chart* srcend) {
  var uintL count = srcend-src;
  var uintL result = 0;
  if (count > 0) {
    var const nls_table* table = (const nls_table*)
      TheMachine(TheEncoding(encoding)->enc_table);
    var const unsigned char* const* cvtable = table->page_uni2charset;
    dotimespL(count,count, {
      var chart ch = *src++;
      if (as_cint(ch) < 0x10000
          && (cvtable[as_cint(ch)>>8][as_cint(ch)&0xFF] != 0
              || chareq(ch,ascii(0))))
        result++;
      else {
        var object action = TheEncoding(encoding)->enc_tombs_error;
        if (eq(action,S(Kignore))) {
        } else if (uint8_p(action)) {
          result++;
        } else if (!eq(action,S(Kerror))) {
          var chart c = char_code(action);
          if (as_cint(c) < 0x10000
              && (cvtable[as_cint(c)>>8][as_cint(c)&0xFF] != 0
                  || chareq(c,ascii(0))))
            result++;
        }
      }
     });
  }
  return result;
}

global void nls_wcstombs (object encoding, object stream,
                          const chart* *srcp, const chart* srcend,
                          uintB* *destp, uintB* destend) {
  var const chart* src = *srcp;
  var uintB* dest = *destp;
  var uintL scount = srcend-src;
  var uintL dcount = destend-dest;
  if (scount > 0 && dcount > 0) {
    var const nls_table* table = (const nls_table*)
      TheMachine(TheEncoding(encoding)->enc_table);
    var const unsigned char* const* cvtable = table->page_uni2charset;
    do {
      var chart ch = *src++; scount--;
      var uintB b;
      if (as_cint(ch) < 0x10000
          && (b = cvtable[as_cint(ch)>>8][as_cint(ch)&0xFF],
              b != 0 || chareq(ch,ascii(0)))) {
        *dest++ = b; dcount--;
      } else {
        var object action = TheEncoding(encoding)->enc_tombs_error;
        if (eq(action,S(Kignore))) {
        } else if (uint8_p(action)) {
          *dest++ = I_to_uint8(action); dcount--;
        } else if (!eq(action,S(Kerror))) {
          var chart c = char_code(action);
          if (as_cint(c) < 0x10000
              && (b = cvtable[as_cint(c)>>8][as_cint(c)&0xFF],
                  b != 0 || chareq(c,ascii(0)))) {
            *dest++ = b; dcount--;
          } else
            fehler_unencodable(encoding,ch);
        } else
          fehler_unencodable(encoding,ch);
      }
    } while (scount > 0 && dcount > 0);
    *srcp = src;
    *destp = dest;
  }
}

# Same thing, specially optimized for ASCII extensions.

global uintL nls_asciiext_wcslen (object encoding, const chart* src,
                                  const chart* srcend) {
  var uintL count = srcend-src;
  var uintL result = 0;
  if (count > 0) {
    var const nls_table* table = (const nls_table*)
      TheMachine(TheEncoding(encoding)->enc_table);
    var const unsigned char* const* cvtable = table->page_uni2charset;
    dotimespL(count,count, {
      var chart ch = *src++;
      if (as_cint(ch) < 0x80
          || (as_cint(ch) < 0x10000
              && cvtable[as_cint(ch)>>8][as_cint(ch)&0xFF] != 0))
        result++;
      else {
        var object action = TheEncoding(encoding)->enc_tombs_error;
        if (eq(action,S(Kignore))) {
        } else if (uint8_p(action)) {
          result++;
        } else if (!eq(action,S(Kerror))) {
          var chart c = char_code(action);
          if (as_cint(c) < 0x10000
              && (cvtable[as_cint(c)>>8][as_cint(c)&0xFF] != 0
                  || chareq(c,ascii(0))))
            result++;
        }
      }
    });
  }
  return result;
}

global void nls_asciiext_wcstombs (object encoding, object stream,
                                   const chart* *srcp, const chart* srcend,
                                   uintB* *destp, uintB* destend) {
  var const chart* src = *srcp;
  var uintB* dest = *destp;
  var uintL scount = srcend-src;
  var uintL dcount = destend-dest;
  if (scount > 0 && dcount > 0) {
    var const nls_table* table = (const nls_table*)
      TheMachine(TheEncoding(encoding)->enc_table);
    var const unsigned char* const* cvtable = table->page_uni2charset;
    do {
      var chart ch = *src++; scount--;
      if (as_cint(ch) < 0x80) {
        *dest++ = (uintB)as_cint(ch); # avoid memory reference (big speedup!)
        dcount--;
      } else {
        var uintB b;
        if (as_cint(ch) < 0x10000
            && (b = cvtable[as_cint(ch)>>8][as_cint(ch)&0xFF],
                b != 0)) {
          *dest++ = b; dcount--;
        } else {
          var object action = TheEncoding(encoding)->enc_tombs_error;
          if (eq(action,S(Kignore))) {
          } else if (uint8_p(action)) {
            *dest++ = I_to_uint8(action); dcount--;
          } else if (!eq(action,S(Kerror))) {
            var chart c = char_code(action);
            if (as_cint(c) < 0x10000
                && (b = cvtable[as_cint(c)>>8][as_cint(c)&0xFF],
                    b != 0 || chareq(c,ascii(0)))) {
              *dest++ = b; dcount--;
            } else
              fehler_unencodable(encoding,ch);
          } else
            fehler_unencodable(encoding,ch);
        }
      }
    } while (scount > 0 && dcount > 0);
    *srcp = src;
    *destp = dest;
  }
}

# Determining the range of encodable characters.
global object nls_range (object encoding, uintL start, uintL end) {
  var uintL count = 0; # number of intervals already on the STACK
  # The range lies in the BMP; no need to look beyond U+FFFF.
  if (start < 0x10000) {
    if (end >= 0x10000)
      end = 0xFFFF;
    var const nls_table* table =
      (const nls_table*) TheMachine(TheEncoding(encoding)->enc_table);
    var const unsigned char* const* cvtable = table->page_uni2charset;
    var uintL i1;
    var uintL i2;
    var bool have_i1_i2 = false; # [i1,i2] = interval being built
    var uintL i;
    for (i = start;;) {
      # Here i < 0x10000.
      var chart ch = as_chart(i);
      if (cvtable[as_cint(ch)>>8][as_cint(ch)&0xFF] != 0
          || chareq(ch,ascii(0))) {
        # ch encodable -> extend the interval
        if (!have_i1_i2) {
          have_i1_i2 = true; i1 = i;
        }
        i2 = i;
      } else {
        # ch not encodable -> finish the interval
        if (have_i1_i2) {
          pushSTACK(code_char(as_chart(i1))); pushSTACK(code_char(as_chart(i2)));
          check_STACK(); count++;
        }
        have_i1_i2 = false;
      }
      if (i == end)
        break;
      i++;
    }
    if (have_i1_i2) {
      pushSTACK(code_char(as_chart(i1))); pushSTACK(code_char(as_chart(i2)));
      check_STACK(); count++;
    }
  }
  return stringof(2*count);
}

# -----------------------------------------------------------------------------
#                             iconv-based encodings

# They are defined in stream.d because they need to access internals of
# the ChannelStream.

#if defined(GNU_LIBICONV) || defined(HAVE_ICONV)

extern uintL iconv_mblen (object encoding, const uintB* src,
                          const uintB* srcend);
extern void iconv_mbstowcs (object encoding, object stream, const uintB* *srcp,
                            const uintB* srcend, chart* *destp,
                            chart* destend);
extern uintL iconv_wcslen (object encoding, const chart* src,
                           const chart* srcend);
extern void iconv_wcstombs (object encoding, object stream, const chart* *srcp,
                            const chart* srcend, uintB* *destp,
                            uintB* destend);
extern object iconv_range (object encoding, uintL start, uintL end);

#endif # GNU_LIBICONV || HAVE_ICONV

#ifdef GNU_LIBICONV

#define iconv_first_sym  S(koi8_ru)
#define iconv_last_sym  S(utf_7)
#define iconv_num_encodings  (&symbol_tab_data.S_utf_7 - &symbol_tab_data.S_koi8_ru + 1)

#endif

# -----------------------------------------------------------------------------

#endif # UNICODE

# =============================================================================
#                              General functions

# (MAKE-ENCODING [:charset] [:line-terminator] [:input-error-action]
#                [:output-error-action])
# creates a new encoding.
LISPFUN(make_encoding,0,0,norest,key,4,
        (kw(charset),kw(line_terminator),
         kw(input_error_action),kw(output_error_action))) {
  var object arg;
  var object sym;
  # Check the :CHARSET argument.
  arg = STACK_3;
  # string -> symbol in CHARSET
  if (eq(arg,unbound) || eq(arg,S(Kdefault))) {
    arg = O(default_file_encoding);
  } else if (encodingp(arg)) {
  }
 #ifdef UNICODE
  else if (symbolp(arg) && constantp(TheSymbol(arg))
           && encodingp(Symbol_value(arg))) {
    arg = Symbol_value(arg);
  } else if (stringp(arg)
             && (find_external_symbol(arg,O(charset_package),&sym)
                 || find_external_symbol(arg=string_upcase(arg),
                                         O(charset_package),&sym))
             && constantp(TheSymbol(sym)) && encodingp(Symbol_value(sym))) {
    arg = Symbol_value(sym);
  }
  #if defined(GNU_LIBICONV) || defined(HAVE_ICONV)
  else if (stringp(arg)) {
    with_string_0(arg,Symbol_value(S(ascii)),charset_ascii,
                  { check_charset(charset_ascii,arg); });
    pushSTACK(coerce_ss(arg));
    var object encoding = allocate_encoding();
    TheEncoding(encoding)->enc_eol = S(Kunix);
    TheEncoding(encoding)->enc_towcs_error = S(Kerror);
    TheEncoding(encoding)->enc_tombs_error = S(Kerror);
    TheEncoding(encoding)->enc_charset = popSTACK();
    TheEncoding(encoding)->enc_mblen    = P(iconv_mblen);
    TheEncoding(encoding)->enc_mbstowcs = P(iconv_mbstowcs);
    TheEncoding(encoding)->enc_wcslen   = P(iconv_wcslen);
    TheEncoding(encoding)->enc_wcstombs = P(iconv_wcstombs);
    TheEncoding(encoding)->enc_range    = P(iconv_range);
    TheEncoding(encoding)->min_bytes_per_char = 1;
    TheEncoding(encoding)->max_bytes_per_char = max_bytes_per_chart; # wild assumption
    arg = encoding;
  }
  #endif
 #endif
  else {
    pushSTACK(arg); # TYPE-ERROR slot DATUM
    pushSTACK(S(encoding)); # TYPE-ERROR slot EXPECTED-TYPE
    pushSTACK(arg); pushSTACK(S(Kcharset)); pushSTACK(S(make_encoding));
    fehler(type_error,GETTEXT("~: illegal ~ argument ~"));
  }
  STACK_3 = arg;
  # Check the :LINE-TERMINATOR argument.
  arg = STACK_2;
  if (!(eq(arg,unbound)
        || eq(arg,S(Kunix)) || eq(arg,S(Kmac)) || eq(arg,S(Kdos)))) {
    pushSTACK(arg); # TYPE-ERROR slot DATUM
    pushSTACK(O(type_line_terminator)); # TYPE-ERROR slot EXPECTED-TYPE
    pushSTACK(arg); pushSTACK(S(Kline_terminator));
    pushSTACK(S(make_encoding));
    fehler(type_error,GETTEXT("~: illegal ~ argument ~"));
  }
  # Check the :INPUT-ERROR-ACTION argument.
  arg = STACK_1;
  if (!(eq(arg,unbound)
        || eq(arg,S(Kerror)) || eq(arg,S(Kignore)) || charp(arg))) {
    pushSTACK(arg); # TYPE-ERROR slot DATUM
    pushSTACK(O(type_input_error_action)); # TYPE-ERROR slot EXPECTED-TYPE
    pushSTACK(arg); pushSTACK(S(Kinput_error_action));
    pushSTACK(S(make_encoding));
    fehler(type_error,GETTEXT("~: illegal ~ argument ~"));
  }
  # Check the :OUTPUT-ERROR-ACTION argument.
  arg = STACK_0;
  if (!(eq(arg,unbound)
        || eq(arg,S(Kerror)) || eq(arg,S(Kignore))
        || charp(arg) || uint8_p(arg))) {
    pushSTACK(arg); # TYPE-ERROR slot DATUM
    pushSTACK(O(type_output_error_action)); # TYPE-ERROR slot EXPECTED-TYPE
    pushSTACK(arg); pushSTACK(S(Koutput_error_action));
    pushSTACK(S(make_encoding));
    fehler(type_error,GETTEXT("~: illegal ~ argument ~"));
  }
  # Create a new encoding.
  if ((eq(STACK_2,unbound) || eq(STACK_2,TheEncoding(STACK_3)->enc_eol))
      && (eq(STACK_1,unbound)
          || eq(STACK_1,TheEncoding(STACK_3)->enc_towcs_error))
      && (eq(STACK_0,unbound)
          || eq(STACK_0,TheEncoding(STACK_3)->enc_tombs_error))) {
    value1 = STACK_3;
  } else {
    var object encoding = allocate_encoding();
    var object old_encoding = STACK_3;
    {
      var const object* ptr1 = &TheRecord(old_encoding)->recdata[0];
      var object* ptr2 = &TheRecord(encoding)->recdata[0];
      var uintC count;
      dotimesC(count,encoding_length, { *ptr2++ = *ptr1++; } );
      memcpy(ptr2,ptr1,encoding_xlength);
    }
    if (!eq(STACK_2,unbound))
      TheEncoding(encoding)->enc_eol = STACK_2;
    if (!eq(STACK_1,unbound))
      TheEncoding(encoding)->enc_towcs_error = STACK_1;
    if (!eq(STACK_0,unbound))
      TheEncoding(encoding)->enc_tombs_error = STACK_0;
    value1 = encoding;
  }
  mv_count=1;
  skipSTACK(4);
}

# (SYSTEM::ENCODINGP object)
LISPFUNN(encodingp,1) {
  var object arg = popSTACK();
  value1 = (encodingp(arg) ? T : NIL); mv_count=1;
}

# Report an error when the argument is not an encoding:
# > obj: the bad argument
# > subr_self: caller (a SUBR)
nonreturning_function(local, fehler_encoding, (object obj)) {
  pushSTACK(obj); # TYPE-ERROR slot DATUM
  pushSTACK(S(encoding)); # TYPE-ERROR slot EXPECTED-TYPE
  pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
  fehler(type_error,GETTEXT("~: argument ~ is not a character set"));
}

# (SYSTEM::CHARSET-TYPEP object encoding)
# tests whether the object is a character belonging to the given character set.
LISPFUNN(charset_typep,2) {
  var object encoding = STACK_0;
  if (!encodingp(encoding))
    fehler_encoding(encoding);
  var object obj = STACK_1;
  if (charp(obj)) {
   #ifdef UNICODE
    var uintL i = as_cint(char_code(obj));
    obj = Encoding_range(encoding)(encoding,i,i);
    value1 = (Svector_length(obj) > 0 ? T : NIL); mv_count=1;
   #else
    value1 = T; mv_count=1;
   #endif
  } else {
    value1 = NIL; mv_count=1;
  }
  skipSTACK(2);
}

# (EXT:ENCODING-CHARSET encoding) --> charset
LISPFUNN(encoding_charset,1) {
  var object encoding = popSTACK();
  if (!encodingp(encoding))
    fehler_encoding(encoding);
  value1 = TheEncoding(encoding)->enc_charset;
  mv_count = 1;
}

#ifdef UNICODE

# (SYSTEM::CHARSET-RANGE encoding char1 char2)
# returns the range of characters in [char1,char2] encodable in the encoding.
LISPFUNN(charset_range,3) {
  var object encoding = STACK_2;
  if (!encodingp(encoding))
    fehler_encoding(encoding);
  if (!charp(STACK_1))
    fehler_char(STACK_1);
  if (!charp(STACK_0))
    fehler_char(STACK_0);
  var uintL i1 = as_cint(char_code(STACK_1));
  var uintL i2 = as_cint(char_code(STACK_0));
  if (i1 <= i2)
    value1 = Encoding_range(encoding)(encoding,i1,i2);
  else
    value1 = O(empty_string);
  mv_count=1;
  skipSTACK(3);
}

#endif

# -----------------------------------------------------------------------------
#                          Elementary string functions

# UP: return a LISP string the given contents.
# n_char_to_string(charptr,len,encoding)
# > char* charptr: the address of the character sequence
# > uintL len: its length
# > object encoding: Encoding
# < return: normal-simple-string with len characters as content
# can trigger GC
#ifdef UNICODE
global object n_char_to_string (const char* srcptr, uintL blen,
                                object encoding) {
  var const uintB* bptr = (const uintB*)srcptr;
  var const uintB* bendptr = bptr+blen;
  var uintL clen = Encoding_mblen(encoding)(encoding,bptr,bendptr);
  pushSTACK(encoding);
  var object obj = allocate_string(clen);
  encoding = popSTACK();
  {
    var chart* cptr = &TheSstring(obj)->data[0];
    var chart* cendptr = cptr+clen;
    Encoding_mbstowcs(encoding)(encoding,nullobj,&bptr,bendptr,&cptr,cendptr);
    ASSERT(cptr == cendptr);
  }
  return obj;
}
#else
global object n_char_to_string_ (const char* srcptr, uintL len) {
  var const uintB* bptr = (const uintB*)srcptr;
  var object obj = allocate_string(len);
  if (len > 0) {
    var chart* ptr = &TheSstring(obj)->data[0];
    # copy bptr to ptr as characters:
    dotimespL(len,len, { *ptr++ = as_chart(*bptr++); } );
  }
  return obj;
}
#endif

# UP: Convert an ASCIZ string to a LISP string
# asciz_to_string(asciz,encoding)
# ascii_to_string(asciz)
# > char* asciz: ASCIZ-String (NULL-terminated)
# > object encoding: Encoding
# < return: normal-simple-string the same string (without NULL)
# can trigger GC
#ifdef UNICODE
global object asciz_to_string (const char * asciz, object encoding) {
  return n_char_to_string(asciz,asciz_length(asciz),encoding);
}
#else
global object asciz_to_string_ (const char * asciz) {
  return n_char_to_string_(asciz,asciz_length(asciz));
}
#endif
global object ascii_to_string (const char * asciz) {
  var const uintB* bptr = (const uintB*)asciz;
  var uintL len = asciz_length(asciz);
  var object obj = allocate_s8string(len); # String allozieren
  if (len > 0) {
    var cint8* ptr = &TheS8string(obj)->data[0];
    # copy as characters bptr --> ptr:
    dotimespL(len,len, {
      var uintB b = *bptr++;
      ASSERT(b < 0x80);
      *ptr++ = (cint8)b;
    });
  }
  return obj;
}

# UP: Convert a LISP string to an ASCIZ string.
# string_to_asciz(obj,encoding)
# > object obj: String
# > object encoding: Encoding
# < return: simple-bit-vector with the bytes<==characters and a NULL at the end
# < TheAsciz(ergebnis): address of the byte sequence contain therein
# can trigger GC
#ifdef UNICODE
global object string_to_asciz (object obj, object encoding) {
  var uintL len;
  var uintL offset;
  var object string = unpack_string_ro(obj,&len,&offset);
  var const chart* srcptr;
  unpack_sstring_alloca(string,len,offset, srcptr=);
  var uintL bytelen = cslen(encoding,srcptr,len);
  pushSTACK(encoding);
  pushSTACK(string);
  var object newasciz = allocate_bit_vector(Atype_8Bit,bytelen+1);
  string = popSTACK();
  encoding = popSTACK();
  unpack_sstring_alloca(string,len,offset, srcptr=);
  cstombs(encoding,srcptr,len,&TheSbvector(newasciz)->data[0],bytelen);
  TheSbvector(newasciz)->data[bytelen] = '\0';
  return newasciz;
}
#else
global object string_to_asciz_ (object obj) {
  pushSTACK(obj); # String retten
  var object newasciz = allocate_bit_vector(Atype_8Bit,vector_length(obj)+1);
  obj = popSTACK(); # String zurück
  {
    var uintL len;
    var uintL offset;
    var object string = unpack_string_ro(obj,&len,&offset);
    var const chart* sourceptr = &TheSstring(string)->data[offset];
    # Source-String: Länge in len, Bytes ab sourceptr
    var uintB* destptr = &TheSbvector(newasciz)->data[0];
    # Destination-String: Bytes ab destptr
    {
      # Kopierschleife:
      var uintL count;
      dotimesL(count,len, { *destptr++ = as_cint(*sourceptr++); } );
      *destptr++ = '\0'; # Nullbyte anfügen
    }
  }
  return newasciz;
}
#endif

# =============================================================================
#                               Initialization

# Initialize the encodings.
# init_encodings();
global void init_encodings_1 (void) {
  # Compile-time checks:
  ASSERT(sizeof(chart) == sizeof(cint));
 #ifdef UNICODE
  {
    var object symbol = S(unicode_16_big_endian);
    var object encoding = allocate_encoding();
    TheEncoding(encoding)->enc_eol = S(Kunix);
    TheEncoding(encoding)->enc_towcs_error = S(Kerror);
    TheEncoding(encoding)->enc_tombs_error = S(Kerror);
    TheEncoding(encoding)->enc_charset = symbol;
    TheEncoding(encoding)->enc_mblen    = P(uni16_mblen);
    TheEncoding(encoding)->enc_mbstowcs = P(uni16be_mbstowcs);
    TheEncoding(encoding)->enc_wcslen   = P(uni16_wcslen);
    TheEncoding(encoding)->enc_wcstombs = P(uni16be_wcstombs);
    TheEncoding(encoding)->enc_range    = P(bmp_range);
    TheEncoding(encoding)->min_bytes_per_char = 2;
    TheEncoding(encoding)->max_bytes_per_char = 2;
    define_constant(symbol,encoding);
  }
  {
    var object symbol = S(unicode_16_little_endian);
    var object encoding = allocate_encoding();
    TheEncoding(encoding)->enc_eol = S(Kunix);
    TheEncoding(encoding)->enc_towcs_error = S(Kerror);
    TheEncoding(encoding)->enc_tombs_error = S(Kerror);
    TheEncoding(encoding)->enc_charset = symbol;
    TheEncoding(encoding)->enc_mblen    = P(uni16_mblen);
    TheEncoding(encoding)->enc_mbstowcs = P(uni16le_mbstowcs);
    TheEncoding(encoding)->enc_wcslen   = P(uni16_wcslen);
    TheEncoding(encoding)->enc_wcstombs = P(uni16le_wcstombs);
    TheEncoding(encoding)->enc_range    = P(bmp_range);
    TheEncoding(encoding)->min_bytes_per_char = 2;
    TheEncoding(encoding)->max_bytes_per_char = 2;
    define_constant(symbol,encoding);
  }
  {
    var object symbol = S(unicode_32_big_endian);
    var object encoding = allocate_encoding();
    TheEncoding(encoding)->enc_eol = S(Kunix);
    TheEncoding(encoding)->enc_towcs_error = S(Kerror);
    TheEncoding(encoding)->enc_tombs_error = S(Kerror);
    TheEncoding(encoding)->enc_charset = symbol;
    TheEncoding(encoding)->enc_mblen    = P(uni32be_mblen);
    TheEncoding(encoding)->enc_mbstowcs = P(uni32be_mbstowcs);
    TheEncoding(encoding)->enc_wcslen   = P(uni32_wcslen);
    TheEncoding(encoding)->enc_wcstombs = P(uni32be_wcstombs);
    TheEncoding(encoding)->enc_range    = P(all_range);
    TheEncoding(encoding)->min_bytes_per_char = 4;
    TheEncoding(encoding)->max_bytes_per_char = 4;
    define_constant(symbol,encoding);
  }
  {
    var object symbol = S(unicode_32_little_endian);
    var object encoding = allocate_encoding();
    TheEncoding(encoding)->enc_eol = S(Kunix);
    TheEncoding(encoding)->enc_towcs_error = S(Kerror);
    TheEncoding(encoding)->enc_tombs_error = S(Kerror);
    TheEncoding(encoding)->enc_charset = symbol;
    TheEncoding(encoding)->enc_mblen    = P(uni32le_mblen);
    TheEncoding(encoding)->enc_mbstowcs = P(uni32le_mbstowcs);
    TheEncoding(encoding)->enc_wcslen   = P(uni32_wcslen);
    TheEncoding(encoding)->enc_wcstombs = P(uni32le_wcstombs);
    TheEncoding(encoding)->enc_range    = P(all_range);
    TheEncoding(encoding)->min_bytes_per_char = 4;
    TheEncoding(encoding)->max_bytes_per_char = 4;
    define_constant(symbol,encoding);
  }
  {
    var object symbol = S(utf_8);
    var object encoding = allocate_encoding();
    TheEncoding(encoding)->enc_eol = S(Kunix);
    TheEncoding(encoding)->enc_towcs_error = S(Kerror);
    TheEncoding(encoding)->enc_tombs_error = S(Kerror);
    TheEncoding(encoding)->enc_charset = symbol;
    TheEncoding(encoding)->enc_mblen    = P(utf8_mblen);
    TheEncoding(encoding)->enc_mbstowcs = P(utf8_mbstowcs);
    TheEncoding(encoding)->enc_wcslen   = P(utf8_wcslen);
    TheEncoding(encoding)->enc_wcstombs = P(utf8_wcstombs);
    TheEncoding(encoding)->enc_range    = P(all_range);
    TheEncoding(encoding)->min_bytes_per_char = 1;
    TheEncoding(encoding)->max_bytes_per_char = 4;
    define_constant(symbol,encoding);
  }
  {
    var object symbol = S(java);
    var object encoding = allocate_encoding();
    TheEncoding(encoding)->enc_eol = S(Kunix);
    TheEncoding(encoding)->enc_towcs_error = S(Kerror);
    TheEncoding(encoding)->enc_tombs_error = S(Kerror);
    TheEncoding(encoding)->enc_charset = symbol;
    TheEncoding(encoding)->enc_mblen    = P(java_mblen);
    TheEncoding(encoding)->enc_mbstowcs = P(java_mbstowcs);
    TheEncoding(encoding)->enc_wcslen   = P(java_wcslen);
    TheEncoding(encoding)->enc_wcstombs = P(java_wcstombs);
    TheEncoding(encoding)->enc_range    = P(all_range);
    TheEncoding(encoding)->min_bytes_per_char = 1;
    TheEncoding(encoding)->max_bytes_per_char = 12;
    define_constant(symbol,encoding);
  }
 #endif
}
global void init_encodings_2 (void) {
 #ifdef UNICODE
  {
    var object symbol = nls_first_sym;
    var const nls_table * const * ptr = &nls_tables[0];
    var uintC count;
    ASSERT(nls_num_encodings == sizeof(nls_tables)/sizeof(nls_tables[0]));
    dotimesC(count,sizeof(nls_tables)/sizeof(nls_tables[0]), {
      var object encoding = allocate_encoding();
      TheEncoding(encoding)->enc_eol = S(Kunix);
      TheEncoding(encoding)->enc_towcs_error = S(Kerror);
      TheEncoding(encoding)->enc_tombs_error = S(Kerror);
      TheEncoding(encoding)->enc_charset = symbol;
      if ((*ptr)->is_ascii_extension) {
        TheEncoding(encoding)->enc_mblen    = P(nls_asciiext_mblen);
        TheEncoding(encoding)->enc_mbstowcs = P(nls_asciiext_mbstowcs);
        TheEncoding(encoding)->enc_wcslen   = P(nls_asciiext_wcslen);
        TheEncoding(encoding)->enc_wcstombs = P(nls_asciiext_wcstombs);
      } else {
        TheEncoding(encoding)->enc_mblen    = P(nls_mblen);
        TheEncoding(encoding)->enc_mbstowcs = P(nls_mbstowcs);
        TheEncoding(encoding)->enc_wcslen   = P(nls_wcslen);
        TheEncoding(encoding)->enc_wcstombs = P(nls_wcstombs);
      }
      TheEncoding(encoding)->enc_range    = P(nls_range);
      TheEncoding(encoding)->enc_table    = make_machine(*ptr);
      TheEncoding(encoding)->min_bytes_per_char = 1;
      TheEncoding(encoding)->max_bytes_per_char = 1;
      define_constant(symbol,encoding);
      symbol = objectplus(symbol,(soint)sizeof(*TheSymbol(symbol))<<(oint_addr_shift-addr_shift));
      ptr++;
    });
  }
  # Now some aliases.
  define_constant(S(unicode_16),Symbol_value(S(unicode_16_big_endian))); # network byte order = big endian
  define_constant(S(unicode_32),Symbol_value(S(unicode_32_big_endian))); # network byte order = big endian
  define_constant(S(ucs_2),Symbol_value(S(unicode_16)));
  define_constant(S(ucs_4),Symbol_value(S(unicode_32)));
  define_constant(S(macintosh),Symbol_value(S(mac_roman)));
  define_constant(S(windows_1250),Symbol_value(S(cp1250)));
  define_constant(S(windows_1251),Symbol_value(S(cp1251)));
  define_constant(S(windows_1252),Symbol_value(S(cp1252)));
  define_constant(S(windows_1253),Symbol_value(S(cp1253)));
  define_constant(S(windows_1254),Symbol_value(S(cp1254)));
  define_constant(S(windows_1255),Symbol_value(S(cp1255)));
  define_constant(S(windows_1256),Symbol_value(S(cp1256)));
  define_constant(S(windows_1257),Symbol_value(S(cp1257)));
  define_constant(S(windows_1258),Symbol_value(S(cp1258)));
 #ifdef GNU_LIBICONV
  {
    var object symbol = iconv_first_sym;
    var uintC count;
    dotimesC(count,iconv_num_encodings, {
      pushSTACK(Symbol_name(symbol));
      pushSTACK(unbound); pushSTACK(unbound); pushSTACK(unbound);
      C_make_encoding(); # cannot use funcall yet
      define_constant(symbol,value1);
      symbol = objectplus(symbol,(soint)sizeof(*TheSymbol(symbol))<<(oint_addr_shift-addr_shift));
    });
  }
 #endif
  # Initialize O(internal_encoding):
  pushSTACK(Symbol_value(S(utf_8)));
  pushSTACK(S(Kunix));
  pushSTACK(unbound);
  pushSTACK(unbound);
  C_make_encoding();
  O(internal_encoding) = value1;
 #endif
  # Initialize locale dependent encodings:
  init_dependent_encodings();
}

# Returns an encoding specified by a name.
# The line-termination is OS dependent.
# encoding_from_name(name)
# > char* name: Any of the canonical names returned by the locale_charset()
#               function.
# can trigger GC
local object encoding_from_name (const char* name) {
 #ifdef UNICODE
  # Attempt to use the character set implicitly specified by the locale.
  if (name && (asciz_equal(name,"ASCII") ||
               asciz_equal(name,"ANSI_X3.4-1968")))
    pushSTACK(Symbol_value(S(ascii)));
  else if (name && asciz_equal(name,"ISO-8859-1"))
    pushSTACK(Symbol_value(S(iso8859_1)));
  else if (name && asciz_equal(name,"ISO-8859-2"))
    pushSTACK(Symbol_value(S(iso8859_2)));
  else if (name && asciz_equal(name,"ISO-8859-3"))
    pushSTACK(Symbol_value(S(iso8859_3)));
  else if (name && asciz_equal(name,"ISO-8859-4"))
    pushSTACK(Symbol_value(S(iso8859_4)));
  else if (name && asciz_equal(name,"ISO-8859-5"))
    pushSTACK(Symbol_value(S(iso8859_5)));
  else if (name && asciz_equal(name,"ISO-8859-6"))
    pushSTACK(Symbol_value(S(iso8859_6)));
  else if (name && asciz_equal(name,"ISO-8859-7"))
    pushSTACK(Symbol_value(S(iso8859_7)));
  else if (name && asciz_equal(name,"ISO-8859-8"))
    pushSTACK(Symbol_value(S(iso8859_8)));
  else if (name && asciz_equal(name,"ISO-8859-9"))
    pushSTACK(Symbol_value(S(iso8859_9)));
  else if (name && asciz_equal(name,"ISO-8859-10"))
    pushSTACK(Symbol_value(S(iso8859_10)));
  else if (name && asciz_equal(name,"ISO-8859-13"))
    pushSTACK(Symbol_value(S(iso8859_13)));
  else if (name && asciz_equal(name,"ISO-8859-14"))
    pushSTACK(Symbol_value(S(iso8859_14)));
  else if (name && asciz_equal(name,"ISO-8859-15"))
    pushSTACK(Symbol_value(S(iso8859_15)));
  else if (name && asciz_equal(name,"ISO-8859-16"))
    pushSTACK(Symbol_value(S(iso8859_16)));
  else if (name && asciz_equal(name,"KOI8-R"))
    pushSTACK(Symbol_value(S(koi8_r)));
  else if (name && asciz_equal(name,"KOI8-U"))
    pushSTACK(Symbol_value(S(koi8_u)));
  else if (name && asciz_equal(name,"CP850"))
    pushSTACK(Symbol_value(S(cp850)));
  else if (name && asciz_equal(name,"CP866"))
    pushSTACK(Symbol_value(S(cp866)));
  else if (name && asciz_equal(name,"CP874"))
    pushSTACK(Symbol_value(S(cp874_ms)));
  else if (name && asciz_equal(name,"CP1250"))
    pushSTACK(Symbol_value(S(windows_1250)));
  else if (name && asciz_equal(name,"CP1251"))
    pushSTACK(Symbol_value(S(windows_1251)));
  else if (name && asciz_equal(name,"CP1252"))
    pushSTACK(Symbol_value(S(windows_1252)));
  else if (name && asciz_equal(name,"CP1253"))
    pushSTACK(Symbol_value(S(windows_1253)));
  else if (name && asciz_equal(name,"CP1254"))
    pushSTACK(Symbol_value(S(windows_1254)));
  else if (name && asciz_equal(name,"CP1255"))
    pushSTACK(Symbol_value(S(windows_1255)));
  else if (name && asciz_equal(name,"CP1256"))
    pushSTACK(Symbol_value(S(windows_1256)));
  else if (name && asciz_equal(name,"CP1257"))
    pushSTACK(Symbol_value(S(windows_1257)));
  else if (name && asciz_equal(name,"HP-ROMAN8"))
    pushSTACK(Symbol_value(S(hp_roman8)));
  #if defined(GNU_LIBICONV)
  else if (name && asciz_equal(name,"CP932"))
    pushSTACK(Symbol_value(S(cp932)));
  else if (name && asciz_equal(name,"CP949"))
    pushSTACK(Symbol_value(S(cp949)));
  else if (name && asciz_equal(name,"CP950"))
    pushSTACK(Symbol_value(S(cp950)));
  else if (name && asciz_equal(name,"GB2312"))
    pushSTACK(Symbol_value(S(euc_cn)));
  else if (name && asciz_equal(name,"EUC-JP"))
    pushSTACK(Symbol_value(S(euc_jp)));
  else if (name && asciz_equal(name,"EUC-KR"))
    pushSTACK(Symbol_value(S(euc_kr)));
  else if (name && asciz_equal(name,"EUC-TW"))
    pushSTACK(Symbol_value(S(euc_tw)));
  else if (name && asciz_equal(name,"BIG5"))
    pushSTACK(Symbol_value(S(big5)));
  else if (name && asciz_equal(name,"BIG5HKSCS"))
    pushSTACK(Symbol_value(S(big5hkscs)));
  else if (name && asciz_equal(name,"GBK"))
    pushSTACK(Symbol_value(S(gbk)));
  else if (name && asciz_equal(name,"GB18030"))
    pushSTACK(Symbol_value(S(gb18030)));
  else if (name && asciz_equal(name,"SJIS"))
    pushSTACK(Symbol_value(S(shift_jis)));
  else if (name && asciz_equal(name,"JOHAB"))
    pushSTACK(Symbol_value(S(johab)));
  else if (name && asciz_equal(name,"TIS-620"))
    pushSTACK(Symbol_value(S(tis_620)));
  else if (name && asciz_equal(name,"VISCII"))
    pushSTACK(Symbol_value(S(viscii)));
  #ifdef UNIX_AIX
  else if (name && asciz_equal(name,"CP856"))
    pushSTACK(Symbol_value(S(cp856)));
  else if (name && asciz_equal(name,"CP922"))
    pushSTACK(Symbol_value(S(cp922)));
  else if (name && asciz_equal(name,"CP943"))
    pushSTACK(Symbol_value(S(cp943)));
  else if (name && asciz_equal(name,"CP1046"))
    pushSTACK(Symbol_value(S(cp1046)));
  else if (name && asciz_equal(name,"CP1124"))
    pushSTACK(Symbol_value(S(cp1124)));
  else if (name && asciz_equal(name,"CP1129"))
    pushSTACK(Symbol_value(S(cp1129)));
  #endif
  #elif (defined(UNIX_LINUX) || defined(UNIX_GNU)) && defined(HAVE_ICONV)
  else if (name && asciz_equal(name,"CP932"))
    pushSTACK(ascii_to_string("CP932"));
  else if (name && asciz_equal(name,"CP949"))
    pushSTACK(ascii_to_string("CP949"));
  else if (name && asciz_equal(name,"CP950"))
    pushSTACK(ascii_to_string("CP950"));
  else if (name && asciz_equal(name,"GB2312"))
    pushSTACK(ascii_to_string("EUC-CN"));
  else if (name && asciz_equal(name,"EUC-JP"))
    pushSTACK(ascii_to_string("EUC-JP"));
  else if (name && asciz_equal(name,"EUC-KR"))
    pushSTACK(ascii_to_string("EUC-KR"));
  else if (name && asciz_equal(name,"EUC-TW"))
    pushSTACK(ascii_to_string("EUC-TW"));
  else if (name && asciz_equal(name,"BIG5"))
    pushSTACK(ascii_to_string("BIG5"));
  else if (name && asciz_equal(name,"BIG5HKSCS"))
    pushSTACK(ascii_to_string("BIG5HKSCS"));
  else if (name && asciz_equal(name,"GBK"))
    pushSTACK(ascii_to_string("GBK"));
  else if (name && asciz_equal(name,"GB18030"))
    pushSTACK(ascii_to_string("GB18030"));
  else if (name && asciz_equal(name,"SJIS"))
    pushSTACK(ascii_to_string("SJIS"));
  else if (name && asciz_equal(name,"JOHAB"))
    pushSTACK(ascii_to_string("JOHAB"));
  else if (name && asciz_equal(name,"TIS-620"))
    pushSTACK(ascii_to_string("TIS-620"));
  else if (name && asciz_equal(name,"VISCII"))
    pushSTACK(ascii_to_string("VISCII"));
  #endif
  else if (name && asciz_equal(name,"UTF-8"))
    pushSTACK(Symbol_value(S(utf_8)));
  else { # Use a reasonable default.
   #if defined(ISOLATIN_CHS)
    pushSTACK(Symbol_value(S(iso8859_1)));
   #elif defined(UTF8_CHS)
    pushSTACK(Symbol_value(S(utf_8)));
   #elif defined(HPROMAN8_CHS)
    pushSTACK(Symbol_value(S(hp_roman8)));
   #elif defined(NEXTSTEP_CHS)
    pushSTACK(Symbol_value(S(nextstep)));
   #elif defined(IBMPC_CHS)
    pushSTACK(Symbol_value(S(cp437_ibm)));
   #else
    pushSTACK(Symbol_value(S(ascii)));
   #endif
  }
 #else
  unused name;
  pushSTACK(unbound);
 #endif # UNICODE
 #if defined(MSDOS) || defined(WIN32) || (defined(UNIX) && (O_BINARY != 0))
  pushSTACK(S(Kdos));
 #else
  pushSTACK(S(Kunix));
 #endif
  pushSTACK(unbound);
  pushSTACK(unbound);
  C_make_encoding();
  return value1;
}

# Initialize the encodings which depend on environment variables.
# init_dependent_encodings();
global void init_dependent_encodings(void) {
#ifdef UNICODE
  extern const char* argv_encoding_file; # override for *default-file-encoding*
  extern const char* argv_encoding_pathname; # override for *pathname-encoding*
  extern const char* argv_encoding_terminal; # override for *terminal-encoding*
  extern const char* argv_encoding_foreign; # override for *foreign-encoding*
  extern const char* argv_encoding_misc; # override for *misc-encoding*
  begin_system_call();
  var const char* locale_encoding = locale_charset(); # depends on environment variables
  end_system_call();
  pushSTACK(encoding_from_name(locale_encoding));
  # Initialize each encoding as follows: If the corresponding -E....
  # option was not given, use the locale dependent locale_charset().
  # If it was given, use that, and if the specified encoding was invalid,
  # use a default encoding that does not depend on the locale.
  O(default_file_encoding) =
    (argv_encoding_file ? encoding_from_name(argv_encoding_file) : STACK_0);
  O(pathname_encoding) =
    (argv_encoding_pathname ? encoding_from_name(argv_encoding_pathname)
     : STACK_0);
 #if defined(WIN32_NATIVE)
  { # cf libiconv/libcharset/lib/localcharset.c locale_charset()
    var const char *enc = argv_encoding_terminal;
    var char buf[2+10+1];
    if (enc == NULL)
      sprintf(enc=buf,"CP%u",GetOEMCP());
    O(terminal_encoding) = encoding_from_name(enc);
  }
 #else
  O(terminal_encoding) =
    (argv_encoding_terminal ? encoding_from_name(argv_encoding_terminal)
     : STACK_0);
 #endif
 #if defined(HAVE_FFI) || defined(HAVE_AFFI)
  O(foreign_encoding) =
    (argv_encoding_foreign ? encoding_from_name(argv_encoding_foreign)
     : STACK_0);
 #endif
  O(misc_encoding) =
    (argv_encoding_misc ? encoding_from_name(argv_encoding_misc) : STACK_0);
  skipSTACK(1);
#else # no UNICODE
  O(default_file_encoding) = encoding_from_name(NULL);
#endif
}

# =============================================================================
#                                 Accessors

# (SYSTEM::DEFAULT-FILE-ENCODING)
LISPFUNN(default_file_encoding,0) {
  value1 = O(default_file_encoding); mv_count=1;
}

# (SYSTEM::SET-DEFAULT-FILE-ENCODING encoding)
LISPFUNN(set_default_file_encoding,1) {
  var object encoding = popSTACK();
  if (!encodingp(encoding))
    fehler_encoding(encoding);
  value1 = O(default_file_encoding) = encoding; mv_count=1;
}

#ifdef UNICODE

# (SYSTEM::PATHNAME-ENCODING)
LISPFUNN(pathname_encoding,0) {
  value1 = O(pathname_encoding); mv_count=1;
}

# (SYSTEM::SET-PATHNAME-ENCODING encoding)
LISPFUNN(set_pathname_encoding,1) {
  var object encoding = popSTACK();
  if (!encodingp(encoding))
    fehler_encoding(encoding);
  value1 = O(pathname_encoding) = encoding; mv_count=1;
}

# (SYSTEM::TERMINAL-ENCODING)
LISPFUNN(terminal_encoding,0) {
  value1 = O(terminal_encoding); mv_count=1;
}

# (SYSTEM::SET-TERMINAL-ENCODING encoding)
LISPFUNN(set_terminal_encoding,1) {
  var object encoding = STACK_0;
  if (!encodingp(encoding))
    fehler_encoding(encoding);
  # Ensure O(terminal_encoding) = (STREAM-EXTERNAL-FORMAT *TERMINAL-IO*).
  # But first modify (STREAM-EXTERNAL-FORMAT *TERMINAL-IO*):
  set_terminalstream_external_format(var_stream(S(terminal_io),0),encoding);
  value1 = O(terminal_encoding) = popSTACK(); mv_count=1;
}

#if defined(HAVE_FFI) || defined(HAVE_AFFI)

# (SYSTEM::FOREIGN-ENCODING)
LISPFUNN(foreign_encoding,0) {
  value1 = O(foreign_encoding); mv_count=1;
}

# (SYSTEM::SET-FOREIGN-ENCODING encoding)
LISPFUNN(set_foreign_encoding,1) {
  var object encoding = popSTACK();
  if (!encodingp(encoding))
    fehler_encoding(encoding);
  if (!(TheEncoding(encoding)->max_bytes_per_char == 1)) {
    pushSTACK(encoding); pushSTACK(TheSubr(subr_self)->name);
    fehler(error,GETTEXT("~: ~ is not a 1:1 encoding"));
  }
  value1 = O(foreign_encoding) = encoding; mv_count=1;
}

#endif # HAVE_FFI || HAVE_AFFI

# (SYSTEM::MISC-ENCODING)
LISPFUNN(misc_encoding,0) {
  value1 = O(misc_encoding); mv_count=1;
}

# (SYSTEM::SET-MISC-ENCODING encoding)
LISPFUNN(set_misc_encoding,1) {
  var object encoding = popSTACK();
  if (!encodingp(encoding))
    fehler_encoding(encoding);
  value1 = O(misc_encoding) = encoding; mv_count=1;
}

#endif # UNICODE

# =============================================================================
#                                More functions

# (CONVERT-STRING-FROM-BYTES byte-array encoding [:start] [:end])
LISPFUN(convert_string_from_bytes,2,0,norest,key,2, (kw(start),kw(end)) ) {
  # Stack layout: array, encoding, start, end.
  var object array = STACK_3;
  # Check array:
  if (!vectorp(array)) fehler_vector(array);
  # Check encoding:
  if (!encodingp(STACK_2)) fehler_encoding(STACK_2);
  # Check start:
  if (eq(STACK_1,unbound)) STACK_1 = Fixnum_0;
  # Check end:
  if (eq(STACK_0,unbound) || eq(STACK_0,NIL))
    STACK_0 = fixnum(vector_length(array));
  # Convert array to a vector with element type (UNSIGNED-BYTE 8):
  if (!bit_vector_p(Atype_8Bit,array)) {
    # (SYS::COERCED-SUBSEQ array '(ARRAY (UNSIGNED-BYTE 8) (*)) [:start] [:end])
    var object old_subr_self = subr_self; # current SUBR, GC invariant!
    pushSTACK(array); pushSTACK(O(type_uint8_vector));
    pushSTACK(S(Kstart)); pushSTACK(STACK_(1+3));
    pushSTACK(S(Kend)); pushSTACK(STACK_(0+5));
    funcall(L(coerced_subseq),6);
    subr_self = old_subr_self;
    array = value1;
    if (!bit_vector_p(Atype_8Bit,array)) { NOTREACHED; }
    STACK_0 = I_I_minus_I(STACK_0,STACK_1); # end := (- end start)
    STACK_1 = Fixnum_0; # start := 0
  }
  # Determine size of result string:
  var uintL start = posfixnum_to_L(STACK_1);
  var uintL end = posfixnum_to_L(STACK_0);
  var uintL index = 0;
  STACK_3 = array = array_displace_check(array,end,&index);
 #ifdef UNICODE
  var uintL clen =
    Encoding_mblen(STACK_2)(STACK_2,&TheSbvector(array)->data[index+start],
                            &TheSbvector(array)->data[index+end]);
 #else
  var uintL clen = end-start;
 #endif
  # Allocate and fill the result string:
  var object string = allocate_string(clen);
  if (clen > 0) {
    array = STACK_3;
    var chart* cptr = &TheSstring(string)->data[0];
    var const uintB* bptr = &TheSbvector(array)->data[index+start];
   #ifdef UNICODE
    var const uintB* bendptr = &TheSbvector(array)->data[index+end];
    var chart* cendptr = cptr+clen;
    Encoding_mbstowcs(STACK_2)(STACK_2,nullobj,&bptr,bendptr,&cptr,cendptr);
    ASSERT(cptr == cendptr);
   #else
    dotimespL(clen,clen, { *cptr++ = as_chart(*bptr++); } );
   #endif
  }
  value1 = string; mv_count=1; skipSTACK(4);
}

# (CONVERT-STRING-TO-BYTES string encoding [:start] [:end])
LISPFUN(convert_string_to_bytes,2,0,norest,key,2, (kw(start),kw(end)) ) {
  # Stack layout: string, encoding, start, end.
  var object string = STACK_3;
  # Check string:
  if (!stringp(string)) fehler_string(string);
  # Check encoding:
  if (!encodingp(STACK_2)) fehler_encoding(STACK_2);
  # Check start:
  if (eq(STACK_1,unbound)) STACK_1 = Fixnum_0;
  # Check end:
  if (eq(STACK_0,unbound) || eq(STACK_0,NIL))
    STACK_0 = fixnum(vector_length(string));
  # Determine size of result string:
  var uintL start = posfixnum_to_L(STACK_1);
  var uintL end = posfixnum_to_L(STACK_0);
  var uintL clen = end-start;
  var uintL index = 0;
  STACK_3 = string = array_displace_check(string,end,&index);
  var const chart* srcptr;
  unpack_sstring_alloca(string,clen,index+start, srcptr=);
  var uintL blen = cslen(STACK_2,srcptr,clen);
  # Allocate and fill the result vector:
  var object array = allocate_bit_vector(Atype_8Bit,blen);
  if (blen > 0) {
    string = STACK_3;
    unpack_sstring_alloca(string,clen,index+start, srcptr=);
    cstombs(STACK_2,srcptr,clen,&TheSbvector(array)->data[0],blen);
  }
  value1 = array; mv_count=1; skipSTACK(4);
}
