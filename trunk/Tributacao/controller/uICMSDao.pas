unit uICMSDao;

interface

uses
  uParametrosImpostosAbstract;

type
  TICMSDao = class(TParametrosImpostosAbstract)
    public
      function GetParametrosImpostos<T>: T; override;
  end;

implementation

{ TICMSDao }


end.
