# Packages - LLMs, etc.
{
  config,
  unstablePkgs,
  ...
}: {
  environment.systemPackages = with unstablePkgs; [
    (llama-cpp.override
      {vulkanSupport = true;})
    (whisper-cpp-vulkan.override
      {vulkanSupport = true;})
  ];
}
