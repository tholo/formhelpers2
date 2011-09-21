import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
README = open(os.path.join(here, 'README.rst')).read()
CHANGES = open(os.path.join(here, 'CHANGES.rst')).read()

requires = [
    'colander',
    'pyramid',
    'pyramid_debugtoolbar',
    'WebHelpers',
    ]

setup(name='formhelpers2',
      version='0.0',
      description='formhelpers2',
      long_description=README + '\n\n' +  CHANGES,
      classifiers=[
        "Programming Language :: Python",
        "Framework :: Pylons",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        ],
      author='',
      author_email='',
      url='',
      keywords='web pyramid pylons',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      install_requires=requires,
      tests_require=requires,
      test_suite="formhelpers2",
      entry_points = """\
      [paste.app_factory]
      main = formhelpers2:main
      """,
      paster_plugins=['pyramid'],
      )
