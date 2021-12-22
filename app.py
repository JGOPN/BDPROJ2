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
    x = db.execute('SELECT COUNT(*) AS artists FROM AUTOR').fetchone()
    stats.update(x)
    x = db.execute('SELECT COUNT(*) AS customers FROM CLIENTE').fetchone()
    stats.update(x)
    x = db.execute('SELECT COUNT(*) AS staff FROM FUNCIONÁRIO ').fetchone()
    stats.update(x)
    logging.info(stats)
    return render_template('index.html',stats=stats)

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
    
  return render_template('album.html', 
           album=album, genre=genre)

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

# FUNCIONARIOS
@APP.route('/funcionarios/')
def list_funcionarios():
    funcionários = db.execute(
      '''
      SELECT ID, Nome, DataNasc, Sexo, Cidade
      FROM FUNCIONÁRIO 
      ORDER BY Nome
      ''').fetchall()
    return render_template('func-list.html', funcionários=funcionários)

@APP.route('/funcionarios/<int:id>/')
def get_funcionario(ID):
  funcionario = db.execute(
      '''
      SELECT ID, Nome, DataNasc, Sexo, Cidade
      FROM FUNCIONÁRIO 
      WHERE ID = %s
      ''', id).fetchone()

  if funcionario is None:
     abort(404, 'Funcionario id {} does not exist.'.format(ID))


