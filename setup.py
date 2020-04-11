from distutils.core import setup
import setup_translate


setup(name = 'enigma2-plugin-extensions-imagemanager',
		version='2.6',
		author='Vasiliks',
		author_email='vasiliks@narod.ru',
		package_dir = {'Extensions.ImageManager': 'src'},
		packages=['Extensions.ImageManager'],
		package_data={'Extensions.ImageManager': ['icon/*.png'], ['bin/*']},
		description = 'Create and manage your image enigma2',
		cmdclass = setup_translate.cmdclass,
	)
