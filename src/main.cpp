#include <boost/program_options.hpp>
#include <iostream>
#include <filesystem>

namespace po = boost::program_options;

void compress(const std::string& inputPath, const std::string& outputDir) {
    std::cout << "Compressing file: " << inputPath << "\n";
    std::cout << "Target output directory: " << outputDir << "\n";
    std::cout << "Compression stub running... (PDAL logic to be added)\n";
}

int main(int argc, char* argv[]) {
    try {
        std::string inputPath;
        std::string outputDir;

        po::options_description desc("LV-Compress - Convert point clouds to LAZ");
        desc.add_options()
            ("help,h", "Show help message")
            ("input,i", po::value<std::string>(&inputPath)->required(), "Input point cloud file")
            ("output,o", po::value<std::string>(&outputDir)->required(), "Output directory");

        po::variables_map vm;
        po::store(po::parse_command_line(argc, argv, desc), vm);

        if (vm.count("help")) {
            std::cout << desc << "\n";
            return 0;
        }

        po::notify(vm);

        if (!std::filesystem::exists(inputPath)) {
            std::cerr << "Error: Input file does not exist.\n";
            return 1;
        }

        if (!std::filesystem::exists(outputDir)) {
            std::cout << "Output directory does not exist. Creating...\n";
            std::filesystem::create_directories(outputDir);
        }

        compress(inputPath, outputDir);
    }
    catch (const po::error& e) {
        std::cerr << "Command line error: " << e.what() << "\n";
        return 1;
    }
    catch (const std::exception& e) {
        std::cerr << "Unhandled exception: " << e.what() << "\n";
        return 1;
    }

    return 0;
}
