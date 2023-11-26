#include <flutter/application.h>
#include "generated_plugin_registrant.h"

int main(int argc, char *argv[]) {
    Application::Initialize(argc, argv);
    RegisterPlugins();
    Application::Launch();
    return 0;
}
