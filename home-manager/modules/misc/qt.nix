{lib, ...}: {
  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "qtct";
    style.name = lib.mkForce "kvantum";
  };
}
