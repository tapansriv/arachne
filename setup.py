from setuptools import setup, find_packages

with open('requirements.txt', 'r') as f:
    reqs = f.read().split('\n')

setup(
    name='arachne',
    version='1.0.0',
    description='Open Source-based Distributed SQL Engine.',
    packages=find_packages(),
    install_requires=reqs
)

