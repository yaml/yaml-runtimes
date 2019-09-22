#include "yaml-cpp/emitterstyle.h"
#include "yaml-cpp/eventhandler.h"
#include "yaml-cpp/yaml.h"  // IWYU pragma: keep

#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <algorithm>

class NullEventHandler : public YAML::EventHandler {
 public:
  typedef YAML::Mark Mark;
  typedef YAML::anchor_t anchor_t;

  NullEventHandler() {}

  virtual void OnDocumentStart(const Mark&) {
      std::cout << "+DOC\n";
  }
  virtual void OnDocumentEnd() {
      std::cout << "-DOC\n";
  }
  virtual void OnNull(const Mark&, anchor_t anch) {
      std::cout << "=VAL";
      if (anch > 0) {
        std::cout << " &" << anch;
      }
      std::cout << " :\n";
  }
  virtual void OnAlias(const Mark&, anchor_t anch) {
      std::cout << "=ALI *" << anch << "\n";
  }
  virtual void OnScalar(const Mark&, const std::string& tag, anchor_t anch,
                        const std::string& str) {
      std::cout << "=VAL";
      if (anch > 0) {
        std::cout << " &" << anch;
      }
      if (tag.compare("?") && tag.compare("!")) {
        std::cout << " <" << tag << ">";
      }
      std::string val = (std::string)str;

      myReplace(val, "\\", "\\\\");
      myReplace(val, "\t", "\\t");
      myReplace(val, "\b", "\\b");
      myReplace(val, "\n", "\\n");
      myReplace(val, "\r", "\\r");
      std::cout << " :" << val << "\n";
  }

  virtual void OnSequenceStart(const Mark&,
          const std::string& tag, anchor_t anch,
          YAML::EmitterStyle::value style) {
      std::cout << "+SEQ";
      if (style == 2) {
          std::cout << " []";
      }
      if (anch > 0) {
        std::cout << " &" << anch;
      }
      if (tag.compare("?")) {
        std::cout << " <" << tag << ">";
      }
      std::cout << "\n";
                               }
  virtual void OnSequenceEnd() {
      std::cout << "-SEQ\n";
  }

  virtual void OnMapStart(const Mark&, const std::string& tag, anchor_t anch,
                          YAML::EmitterStyle::value style) {
      std::cout << "+MAP";
      if (style == 2) {
          std::cout << " {}";
      }
      if (anch > 0) {
        std::cout << " &" << anch;
      }
      if (tag.compare("?")) {
        std::cout << " <" << tag << ">";
      }
      std::cout << "\n";
                          }
  virtual void OnMapEnd() {
      std::cout << "-MAP\n";
  }

    void myReplace(std::string& str,
            const std::string& oldStr,
            const std::string& newStr) {
        std::string::size_type pos = 0u;
        while((pos = str.find(oldStr, pos)) != std::string::npos){
           str.replace(pos, oldStr.length(), newStr);
           pos += newStr.length();
        }
    }

};

void run(std::istream& in) {
    YAML::Parser parser(in);
    NullEventHandler handler;
    int res;
    std::cout << "+STR\n";
    while (res = parser.HandleNextDocument(handler)) {
    }
    std::cout << "-STR\n";
}

void usage() { std::cerr << "Usage: read [filename]\n"; }

std::string read_stream(std::istream& in) {
    return std::string((std::istreambuf_iterator<char>(in)),
        std::istreambuf_iterator<char>());
}

int main(int argc, char** argv) {
    std::string filename;
    for (int i = 1; i < argc; i++) {
        std::string arg = argv[i];
        filename = argv[i];
        if (i + 1 != argc) {
            usage();
            return -1;
        }
    }

    if (filename != "") {
        std::ifstream in(filename);
        in.seekg(std::ios_base::beg);
        run(in);
    }
    else {
        run(std::cin);
    }
    return 0;
}
