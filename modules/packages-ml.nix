# Packages - LLMs, etc.
{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  environment.systemPackages = with unstablePkgs; [
    # Temporarily disabled due to build error on NixOS 25.05
    #    (llama-cpp.override
    #      {vulkanSupport = true;})
    #
    #    (whisper-cpp-vulkan.override
    #      {vulkanSupport = false;})
  ];
}
