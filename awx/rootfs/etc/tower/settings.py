import os
import socket

GLOBAL_JOB_EXECUTION_ENVIRONMENTS = [{'name': 'Nautobot Labs AWX EE (latest)', 'image': 'ghcr.io/abates/ansible-awx-ee:latest'}]
CONTROL_PLANE_EXECUTION_ENVIRONMENT = 'ghcr.io/abates/ansible-awx-ee:latest'
DEFAULT_CONTAINER_RUN_OPTIONS = ['--network', 'slirp4netns:enable_ipv6=false']

ADMINS = ()
STATIC_ROOT = '/var/lib/awx/public/static'
PROJECTS_ROOT = '/var/lib/awx/projects'
JOBOUTPUT_ROOT = '/var/lib/awx/job_status'

SECRET_KEY = 'MbADUwynaTnmODjtCosz'

ALLOWED_HOSTS = ['*']

# Sets Ansible Collection path
AWX_ANSIBLE_COLLECTIONS_PATHS = '/var/lib/awx/vendor/awx_ansible_collections'

# Container environments don't like chroots
AWX_PROOT_ENABLED = False

# Automatically deprovision pods that go offline
AWX_AUTO_DEPROVISION_INSTANCES = True

CLUSTER_HOST_ID = 'awx-localhost'
SYSTEM_UUID = os.environ.get('MY_POD_UID', '00000000-0000-0000-0000-000000000000')

CSRF_COOKIE_SECURE = False
SESSION_COOKIE_SECURE = False

SERVER_EMAIL = 'root@localhost'
DEFAULT_FROM_EMAIL = 'webmaster@localhost'
EMAIL_SUBJECT_PREFIX = '[AWX] '

EMAIL_HOST = 'localhost'
EMAIL_PORT = 25
EMAIL_HOST_USER = ''
EMAIL_HOST_PASSWORD = ''
EMAIL_USE_TLS = False

USE_X_FORWARDED_PORT = True
BROADCAST_WEBSOCKET_PORT = 8052
BROADCAST_WEBSOCKET_PROTOCOL = 'http'

BROKER_URL='redis://awx-redis:6379/'
CHANNEL_LAYERS['default']['CONFIG']['hosts'] = [BROKER_URL]

DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'awx.main.db.profiled_pg',
        'NAME': 'awx',
        'USER': 'awx',
        'PASSWORD': 'shuOKNHPUwtxdxjNjMoZ',
        'HOST': 'awx-db',
        'PORT': '5432',
    }
}

AWX_ISOLATION_SHOW_PATHS = [
    '/etc/pki/ca-trust:/etc/pki/ca-trust',
    '/usr/share/pki:/usr/share/pki',
]
