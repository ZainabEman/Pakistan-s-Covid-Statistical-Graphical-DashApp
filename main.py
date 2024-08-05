import dash
import dash_bootstrap_components as dbc
from dash import dcc, html
from dash.dependencies import Input, Output, State
import pandas as pd
import plotly.express as px
import statsmodels.api as sm

# Load data
file_path =  "E:\SE-A\Projects\pakCovid\PKcovid.csv"
mydata = pd.read_csv(file_path)

# Initialize the app
app = dash.Dash(__name__, external_stylesheets=[dbc.themes.DARKLY])

app.layout = dbc.Container([
    html.H1("Pakistan's Covid Data Analysis", style={"color": "Lime"}),
    dbc.Row([
        dbc.Col([
            dcc.Dropdown(
                id="analysisType",
                options=[
                    {"label": "Summary", "value": "Summary"},
                    {"label": "Probabilities", "value": "Probabilities"},
                    {"label": "Graphs", "value": "Graphs"},
                    {"label": "Predictions", "value": "Predictions"}
                ],
                value="Summary",
                placeholder="Select Analysis Type"
            ),
            dbc.Collapse(
                dbc.Form([
                    dbc.CardGroup([
                        dbc.Label("Case Values For Deaths Prediction:"),
                        dbc.Input(id="newCase", type="number", value=1000)
                    ]),
                    dbc.CardGroup([
                        dbc.Label("Cases Value For Recovery Prediction:"),
                        dbc.Input(id="newCase1", type="number", value=1000)
                    ])
                ]),
                id="predictionInputs",
                is_open=False
            ),
            dbc.Button("Run Analysis", id="runAnalysis", color="primary")
        ], width=12)
    ]),
    dbc.Row([
        dbc.Col([
            html.Div(id="analysisResult"),
            dcc.Graph(id="plotResult"),
            dcc.Graph(id="plotR"),
            dcc.Graph(id="plotResult1"),
            dcc.Graph(id="plotResult2"),
            dcc.Graph(id="plotResult3"),
            dcc.Graph(id="plotResult4"),
            dcc.Graph(id="componentplot"),
            dcc.Graph(id="componentplot_cases"),
            dcc.Graph(id="componentplot_recovery")
        ], width=39)
    ])
])

@app.callback(
    Output("predictionInputs", "is_open"),
    [Input("analysisType", "value")]
)
def toggle_prediction_inputs(analysis_type):
    return analysis_type == "Predictions"

@app.callback(
    [
        Output("analysisResult", "children"),
        Output("plotResult", "figure"),
        Output("plotR", "figure"),
        Output("plotResult1", "figure"),
        Output("plotResult2", "figure"),
        Output("plotResult3", "figure"),
        Output("plotResult4", "figure"),
        Output("componentplot", "figure"),
        Output("componentplot_cases", "figure"),
        Output("componentplot_recovery", "figure")
    ],
    [Input("runAnalysis", "n_clicks")],
    [State("analysisType", "value"), State("newCase", "value"), State("newCase1", "value")]
)
def run_analysis(n_clicks, analysis_type, new_case, new_case1):
    # Define empty figures
    empty_fig = {}

    if not n_clicks:
        return "", empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig

    if analysis_type == "Summary":
        # Summary calculations
        case_summary = mydata['Cases'].describe().to_frame().T
        death_summary = mydata['Deaths'].describe().to_frame().T
        recovery_summary = mydata['Recovered'].describe().to_frame().T

        summary = html.Div([
            html.H2("Summary"),
            html.Table([
                html.Tr([html.Th(col) for col in case_summary.columns]),
                html.Tr([html.Td(cell) for cell in case_summary.iloc[0]])
            ]),
            html.Hr(),
            html.Table([
                html.Tr([html.Th(col) for col in death_summary.columns]),
                html.Tr([html.Td(cell) for cell in death_summary.iloc[0]])
            ]),
            html.Hr(),
            html.Table([
                html.Tr([html.Th(col) for col in recovery_summary.columns]),
                html.Tr([html.Td(cell) for cell in recovery_summary.iloc[0]])
            ])
        ])

        return summary, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig

    elif analysis_type == "Probabilities":
        # Probability calculations
        total = mydata.groupby('Province')['Deaths'].sum()
        total_cases = mydata.groupby('Province')['Cases'].sum()
        death_rate = (total / total_cases * 100).reset_index()

        r_total = mydata.groupby('Province')['Recovered'].sum()
        r_total_cases = mydata.groupby('Province')['Cases'].sum()
        recovery_rate = (r_total / r_total_cases * 100).reset_index()

        fig1 = px.bar(death_rate, x='Province', y='Deaths', title="Probabilities of Death by Province", color='Deaths')
        fig2 = px.bar(recovery_rate, x='Province', y='Recovered', title="Probabilities of Recovery by Province", color='Recovered')

        return "", fig1, fig2, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig

    elif analysis_type == "Graphs":
        # Graph plotting
        fig1 = px.scatter(mydata, x='Province', y='Deaths', title="Scatter Plot of Total Deaths by Province")
        fig2 = px.pie(mydata, values='Cases', names='Province', title="Pie Chart of Cases in Each Province")
        fig3 = px.pie(mydata, values='Deaths', names='Province', title="Pie Chart of Deaths in Each Province")
        fig4 = px.pie(mydata, values='Recovered', names='Province', title="Pie Chart of Recovered in Each Province")

        death_bar = mydata.groupby('Province')['Deaths'].sum().reset_index()
        case_bar = mydata.groupby('Province')['Cases'].sum().reset_index()
        recovery_bar = mydata.groupby('Province')['Recovered'].sum().reset_index()

        fig5 = px.bar(death_bar, x='Province', y='Deaths', title="Component Bar Plot of Deaths")
        fig6 = px.bar(case_bar, x='Province', y='Cases', title="Component Bar Plot of Cases")
        fig7 = px.bar(recovery_bar, x='Province', y='Recovered', title="Component Bar Plot of Recovered")

        return "", empty_fig, empty_fig, fig1, fig2, fig3, fig4, fig5, fig6, fig7

    elif analysis_type == "Predictions":
        # Prediction calculations
        model_death = sm.OLS(mydata['Deaths'], sm.add_constant(mydata['Cases'])).fit()
        predicted_deaths = model_death.predict([1, new_case])

        model_recovery = sm.OLS(mydata['Recovered'], sm.add_constant(mydata['Cases'])).fit()
        predicted_recovery = model_recovery.predict([1, new_case1])

        fig1 = px.scatter(mydata, x='Cases', y='Deaths', title="Linear Regression Predictions")
        fig1.add_scatter(x=[new_case], y=predicted_deaths, mode='markers', name='Predicted Deaths')

        fig2 = px.scatter(mydata, x='Cases', y='Recovered', title="Linear Regression Predictions")
        fig2.add_scatter(x=[new_case1], y=predicted_recovery, mode='markers', name='Predicted Recovery')

        prediction = html.Div([
            html.H2("Predictions"),
            html.P(f"Predicted number of deaths for Cases = {new_case} is {round(predicted_deaths[0])}"),
            html.P(f"Predicted number of Recovered for Cases = {new_case1} is {round(predicted_recovery[0])}")
        ])

        return prediction, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, empty_fig, fig1, fig2, empty_fig

if __name__ == '__main__':
    app.run_server(debug=True)
