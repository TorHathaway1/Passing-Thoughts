ARG PROJECT_NAME='passing_thoughts'
# build environment
FROM node:12.16.1-alpine as build
ARG PROJECT_NAME
WORKDIR /${PROJECT_NAME}
ENV PATH /${PROJECT_NAME}/node_modules/.bin:$PATH
COPY package.json /${PROJECT_NAME}/package.json
RUN yarn install --silent
RUN yarn global add react-scripts@3.0.1 --silent
COPY . /${PROJECT_NAME}
RUN yarn run build
# production environment
FROM nginx:1.16.0-alpine
ARG PROJECT_NAME
RUN echo ${PROJECT_NAME}
COPY --from=build /${PROJECT_NAME}/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 5000
CMD ["nginx", "-g", "daemon off;"]