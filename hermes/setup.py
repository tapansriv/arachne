from setuptools import setup, find_packages

setup(
    name='hermes', 
    version='0.0.1',
    author='Tapan Srivastava',
    description='Hermes tool to do inter-cloud file transfers',
    packages=find_packages(),
    entry_points={
        'console_scripts': [
            'hermes=hermes.run.main:run'
        ]
    },
    install_requires=[
        'boto3',
        'google-cloud-storage',
        'requests',
        'jproperties',
        'botocore',
    ],
)
