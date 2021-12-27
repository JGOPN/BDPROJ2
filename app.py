import warnings
warnings.filterwarnings("ignore", category=FutureWarning)
from flask import abort, render_template, Flask
import logging
import db

APP = Flask(__name__)

# Start page
@APP.route('/')
def index():
    stats = {}
    x = db.execute('SELECT COUNT(*) AS products FROM PRODUTO').fetchone()
    stats.update(x)
    x = db.execute('SELECT COUNT(*) AS compras FROM ENCOMENDA_CLIENTE').fetchone()
    stats.update(x)
    x = db.execute('SELECT COUNT(*) AS fornecedores FROM FORNECEDOR').fetchone()
    stats.update(x)
    logging.info(stats)

    generos = db.execute(
      '''
      SELECT Genero, IdGen FROM GENERO
      '''
    )
    return render_template('index.html',stats=stats,generos=generos)

# Albums
@APP.route('/albums/')
def list_albums():
    albums = db.execute(
      '''
      SELECT IdDisc, Titulo, AnoLançamento, Formato, AUTOR.Nome, GROUP_CONCAT(Genero SEPARATOR ', ') AS Gen
      FROM DISCO JOIN AUTOR ON (Autor = IdAut) NATURAL JOIN GENEROS_DISCO NATURAL JOIN GENERO 
      GROUP BY IdDisc
      ORDER BY Titulo   
      '''
    )
    return render_template('album-list.html', albums=albums)

# Get album by ID
@APP.route('/albums/<int:id>/')
def get_album(id):
  album = db.execute(
      '''
      SELECT IdDisc, Titulo, AnoLançamento, Duracao, Formato, Descricao, AUTOR.Nome
      FROM DISCO JOIN AUTOR ON (Autor = IdAut)
      WHERE IdDisc = %s
      GROUP BY IdDisc
      ''', id).fetchone()

  if album is None:
     abort(404, 'Album id {} does not exist.'.format(id))

  genre = db.execute(
    '''
    SELECT Genero 
    FROM GENERO NATURAL JOIN GENEROS_DISCO 
    WHERE IdDisc = %s
    ''', id).fetchall()
    
  product = db.execute(
    '''
    SELECT NumExemplares, Valor 
    FROM PRODUTO
    WHERE IdDisc = %s 
    ''', id).fetchone()

  return render_template('album.html', 
           album=album, genre=genre, product=product)

# Search album by Title
@APP.route('/albums/search/<expr>/')
def search_albums(expr):
  search = { 'expr': expr }
  expr = '%' + expr + '%'
  album = db.execute(
      ''' 
      SELECT IdDisc, Titulo, AUTOR.Nome
      FROM DISCO JOIN AUTOR ON (Autor = IdAut)
      WHERE Titulo LIKE %s
      ''', expr).fetchall()
  return render_template('album-search.html',
           search=search,album=album)

# Search albums by author
@APP.route('/albums/searchbyaut/<expr>/')
def search_albums_byaut(expr):
  search = { 'expr': expr }
  expr = '%' + expr + '%'
  album = db.execute(
      ''' 
      SELECT IdDisc, Titulo, AUTOR.Nome
      FROM DISCO JOIN AUTOR ON (Autor = IdAut)
      WHERE AUTOR.Nome LIKE %s
      ''', expr).fetchall()
  return render_template('album-search-byaut.html',
           search=search,album=album)

# Search albums by genre
@APP.route('/albums/searchbygen/<expr>/')
def search_by_genre(expr):
  search = { 'expr': expr }
  album = db.execute(
      '''
      SELECT IdDisc, Titulo, AUTOR.Nome, Genero
      FROM DISCO JOIN AUTOR ON (Autor = IdAut) NATURAL JOIN GENEROS_DISCO NATURAL JOIN GENERO
      WHERE Genero = %s
      ''', expr).fetchall()

  return render_template('album-search-bygen.html', album=album, search=search)

# ENCOMENDA_CLIENTE
# Listar todos
@APP.route('/pedidos/')
def list_pedidos():
  pedidos = db.execute(
      '''
      SELECT DataPagamento, ValorTotal, DescontoAplicado, StatusEncomenda, Descricao, ValorDesconto, Nome
      FROM ENCOMENDA_CLIENTE JOIN STATUS_ENCOMENDA ON(ENCOMENDA_CLIENTE.ID = STATUS_ENCOMENDA.Id_Status)
      LEFT JOIN DESCONTO ON(DescontoAplicado = DESCONTO.ID)
      JOIN CLIENTE ON(Cliente = CLIENTE.ID)
      ORDER BY DataPagamento DESC, Cliente
      ''', ).fetchall()
  return render_template('pedido-list.html', pedidos=pedidos)

#Listar por email de cliente
@APP.route('/pedidos/<expr>/')
def pedidos_email(expr):
  email = { 'expr': expr }
  pedidos = db.execute(
      '''
      SELECT DataPagamento, ValorTotal, DescontoAplicado, StatusEncomenda, Descricao, ValorDesconto
      FROM ENCOMENDA_CLIENTE JOIN STATUS_ENCOMENDA ON(ENCOMENDA_CLIENTE.ID = STATUS_ENCOMENDA.Id_Status)
      LEFT JOIN DESCONTO ON(DescontoAplicado=DESCONTO.ID)
        WHERE Cliente = 
          (SELECT ID FROM CLIENTE WHERE Email = %s)
      ORDER BY DataPagamento DESC, Cliente
      ''', expr).fetchall()

  return render_template('pedido-byclient.html', email=email, pedidos=pedidos)

# FUNCIONARIOS

#list all employees
@APP.route('/funcionarios/')
def list_funcionarios():
    funcionarios = db.execute(
      '''
      SELECT ID, Nome, Sexo, Cidade, TIMESTAMPDIFF(YEAR, DataNasc, CURDATE()) AS Idade
      FROM FUNCIONARIO 
      ORDER BY Nome
      ''').fetchall()
    return render_template('func-list.html',funcionarios=funcionarios)

# get employee by ID
@APP.route('/funcionarios/<int:id>/')
def get_funcionario(id):
  funcionarios = db.execute(
      '''
      SELECT FUNCIONARIO.Nome, FUNCIONARIO.ID, CARGO.Nome as Cargo
      FROM FUNCIONARIO JOIN CARGO_FUNCIONARIO ON(FUNCIONARIO.ID = CARGO_FUNCIONARIO.IdFunc)
      JOIN CARGO ON(CARGO.ID = IdCargo)
      WHERE FUNCIONARIO.ID = %s
      ''', id).fetchone()

  if funcionarios is None:
     abort(404, 'Funcionario id {} does not exist.'.format(id))

  return render_template('func.html', funcionarios=funcionarios)


# Search Funcionario by Name
@APP.route('/funcionarios/searchfuncName/<expr>/')
def search_by_name(expr):
  search = { 'expr': expr }
  expr = '%' + expr + '%'
  funcionarios = db.execute(
      '''
      SELECT ID, Nome, DataNasc, Sexo, Cidade
      FROM FUNCIONARIO
      WHERE Nome LIKE %s
      ''', expr).fetchall()

  return render_template('func-search-byName.html', search=search, funcionarios=funcionarios)
