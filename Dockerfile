FROM node:latest AS node_base
RUN echo "NODE Version:" && node --version
RUN echo "NPM Version:" && npm --version

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
COPY --from=node_base . .
RUN npm install twilio-cli -g
RUN twilio plugins:install @twilio-labs/plugin-flex@beta

WORKDIR /src
COPY . .

WORKDIR "/src/tools/Carbon"
RUN dotnet build "Carbon.csproj" -c Release -o ./build

ENTRYPOINT ["dotnet", "./build/Carbon.dll"]