unit uInterface;

interface
  type IInterfaceModelo = interface
    ['{0F0EFA97-A8C5-4340-8697-EC4DB6BC8A0F}']
    procedure Atualizar;
    procedure Inserir;
    procedure Excluir;
    function Pesquisar(Codigo: Integer): Boolean;

end;

implementation

end.
