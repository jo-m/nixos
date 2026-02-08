{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # (llama-cpp.override
    #   {
    #     vulkanSupport = true;
    #     rpcSupport = true;
    #   })

    #    (whisper-cpp-vulkan.override
    #      {vulkanSupport = false;})

    # # For building https://github.com/antirez/flux2.c
    # openblas
    # blas
    # openblasCompat
  ];
}
