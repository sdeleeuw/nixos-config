{
  ...
}:

{
  # Home-manager's default is stable poetry, which runs on Python 3.13.
  # Unstable's runs on 3.14 and would source-build cp313-only wheels such as
  # pydantic-core 2.27.x.
  programs.poetry.enable = true;
}
