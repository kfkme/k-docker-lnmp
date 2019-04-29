	
FROM python:3.6
 
RUN mkdir -p /var/app
WORKDIR /var/app
 
ONBUILD COPY requirements.txt /var/app/
ONBUILD RUN pip install --no-cache-dir -r requirements.txt
 
ONBUILD COPY . /var/app